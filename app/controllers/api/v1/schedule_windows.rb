# frozen_string_literal: true

module Api
  module V1
    class ScheduleWindows < Grape::API
      include Api::V1::Defaults

      helpers SessionHelpers

      before do
        error!('Unauthorized', 401) unless require_login!
      end

      desc 'Get a full schedule for a driver'
      params do
        optional :start, type: DateTime, desc: 'Start date for schedule'
        optional :end, type: DateTime, desc: 'End date for schedule'
      end
      get 'availabilities', root: :schedule_windows do
        start_time = params[:start_time] || DateTime.now
        end_time = params[:end_time] ||  DateTime.now + 3.months
        result = current_driver.events(start_time, end_time)
        if !result.nil?
          status 200
        else
          status 404
        end
        render json: result
      end

      desc 'Get a specific schedule window for a driver'
      params do
        requires :id, type: String, desc: 'ID of the event'
        optional :start_date, type: DateTime, desc: 'Start Date'
        optional :end_date, type: DateTime, desc: 'End Date'
      end
      get 'availabilities/window/:id', root: :schedule_windows do
        begin
          schedule = ScheduleWindow.find(permitted_params[:id])
        rescue ActiveRecord::RecordNotFound
          status 404
          return
        end
        start_time = params[:start_date] || DateTime.now
        end_time = params[:end_date] ||  DateTime.now + 3.months
        result = schedule.events(start_time, end_time)
        if !result.nil?
          status 200
        else
          status 404
        end
        render json: result
      end

      desc 'Create a schedule window for a driver'
      params do
        optional :start_date, type: String, desc: 'Start date and time of when availability would begin recurring'
        optional :end_date, type: String, desc: 'End date and time of when availability would end recurring'
        requires :start_time, type: String, desc: 'Start date and time of availability'
        requires :end_time, type: String, desc: 'End date and time of availability '
        optional :is_recurring, type: Boolean, desc: 'Boolean if availability is recurring or not'
        requires :location_id, type: String, desc: 'ID of location'
        optional :force, type: Boolean, desc: 'Replace overlapping avaliablity'
      end
      post 'availabilities' do
        params[:is_recurring] = false if params[:is_recurring].nil?
        attributes = { start_date: params[:start_date], end_date: params[:end_date],
                       start_time: params[:start_time], end_time: params[:end_time], location_id: params[:location_id],
                       is_recurring: params[:is_recurring] }
        force = params[:force]
        schedule_window = current_driver.schedule_windows.new(attributes)
        if schedule_window.validate
          if params[:is_recurring]
            temp_recurring_pattern = RecurringPattern.new(day_of_week: schedule_window.start_time.wday)
            to_check = schedule_window.projected_weekly_events(
              schedule_window.start_date, schedule_window.end_date, temp_recurring_pattern
            )
          else
            to_check = schedule_window.events(schedule_window.start_time, schedule_window.end_time)
          end
          to_check.each do |event|
            unless find_duplicates(force, event[:startTime], event[:endTime], 0)
              # returns false if no further processing should occur
              return { error: 'This overlaps an existing schedule.', error_code: 101}
            end
          end
        end
        save_return = schedule_window.save
        if save_return
          if schedule_window.is_recurring?
            RecurringPattern.create(schedule_window_id: schedule_window.id, day_of_week: schedule_window.start_time.wday)
          end
          status 201
          schedule_window
        else
          status 400
          { error: schedule_window.errors.full_messages.to_sentence }
        end
      end

      desc 'Update a schedule window for a driver'
      params do
        optional :start_date, type: String, desc: 'Start date and time of when availability would begin recurring'
        optional :end_date, type: String, desc: 'End date and time of when availability would end recurring'
        optional :start_time, type: String, desc: 'Start date and time of availability'
        optional :end_time, type: String, desc: 'End date and time of availability '
        optional :is_recurring, type: Boolean, desc: 'Boolean if availability is recurring or not'
        optional :location_id, type: String, desc: 'ID of location'
        optional :force, type: Boolean, desc: 'Replace overlapping availability'
      end
      put 'availabilities/:id' do
        force = params[:force]

        begin
          schedule_window = current_driver.schedule_windows.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          return 404
        end
        # now we update only what was passed
        changed = false
        if params[:start_date] && params[:start_date].to_datetime != schedule_window.start_date
          schedule_window.start_date = params[:start_date]
          changed = true
        end
        if params[:end_date] && params[:end_date].to_datetime != schedule_window.end_date
          schedule_window.end_date = params[:end_date]
          changed = true
        end
        if params[:start_time] && params[:start_time].to_datetime != schedule_window.start_time
          schedule_window.start_time = params[:start_time]
          changed = true
        end
        if params[:location_id] && params[:location_id] != schedule_window.location_id
          schedule_window[:location_id] = params[:location_id]
          changed = true
        end
        if params[:end_time] && params[:end_time].to_datetime != schedule_window.end_time
          schedule_window.end_time = params[:end_time]
          changed = true
        end
        if params[:is_recurring] && params[:is_recurring] != schedule_window.is_recurring
          schedule_window.is_recurring = params[:is_recurring]
          changed = true
        end
        unless changed
          status 202
          schedule_window
          return
        end
        unless schedule_window.validate
          status 400
          { error: schedule_window.errors.full_messages.to_sentence }
          return
        end
        if !params[:is_recurring]
          to_check = schedule_window.events(schedule_window.start_time, schedule_window.end_time)
        else
          temp_recurring_pattern = RecurringPattern.new(day_of_week: schedule_window.start_time.wday)
          to_check = schedule_window.projected_weekly_events(
            schedule_window.start_date,
            schedule_window.end_date, temp_recurring_pattern
          )
        end
        to_check.each do |event|
          unless find_duplicates(force, event[:startTime], event[:endTime], schedule_window.id)
            return { error: 'This overlaps an existing schedule.', error_code: 101 }
          end
        end
        update_return = schedule_window.save
        pattern = RecurringPattern.find_by(schedule_window_id: schedule_window.id)
        pattern&.destroy
        if schedule_window.is_recurring?
          RecurringPattern.create(schedule_window_id: schedule_window.id, day_of_week: schedule_window.start_time.wday)
        end
        if update_return
          status 202
          schedule_window
        else
          status 400
          { error: schedule_window.errors.full_messages.to_sentence }
        end
      end

      desc 'Delete an availability'
      params do
        requires :id, type: String, desc: 'ID of availability'
      end
      delete 'availabilities/:id' do
        begin
          schedule_window = current_driver.schedule_windows.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          status 404
          return
        end
        if schedule_window.is_recurring
          pattern = RecurringPattern.find_by(schedule_window_id: schedule_window.id)
          pattern.destroy
        end
        schedule_window.destroy
        status 200
      end
    end
  end
end

def find_duplicates(force, start_time, end_time, id)
  duplicate_check_1 = current_driver.overlapping_events(start_time, end_time)
  duplicate_check = []
  if id != 0 # doing an update, some of these duplicates might not count
    duplicate_check.each do |d|
      duplicate_check << d if d.eventId != id
      # we don't count an event as an overlap if we are doing an update of
      # an existing ScheduleWindow and the id of the event matches the
      # id of the schedule window we are updating.  In other words,
      # it doesn't count if a schedule window overlaps with itself.
    end
  else
    duplicate_check = duplicate_check_1
  end
  # Rails.logger.info("in find_duplicates " + start_time.to_s + " " + end_time.to_s)
  # Rails.logger.info("duplicates: " + duplicate_check.inspect)
  unless duplicate_check.empty?
    if !force
      status 400
      return false
    else
      duplicate_check.each do |event|
        old_schedule = ScheduleWindow.find_by(id: event[:eventId])
        next unless old_schedule

        old_schedule.recurring_pattern&.destroy
        old_schedule.destroy
      end
    end
  end
  true
end
