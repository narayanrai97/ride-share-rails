# frozen_string_literal: true

module Api
  module V1
    class Locations < Grape::API
      include Api::V1::Defaults
      helpers SessionHelpers

      before do
        error!('Unauthorized', 401) unless require_login!
      end

      # Lets driver look up resources that do no belong to them
      desc 'Return a location with a given ID'
      params do
        requires :id, type: String, desc: 'ID of the location'
      end
      get 'locations/:id', root: :location do
        begin
          location = Location.find(permitted_params[:id])
        rescue ActiveRecord::RecordNotFound
          status 404
          return {}
        end
        status 200
        render location
      end

      # Returns all locations of the current driver
      desc 'Return all locations for a given driver'
      params do
      end
      get 'locations' do
        location_ids = LocationRelationship.where(driver_id: current_driver.id).select('location_id')
        locations = Location.where(id: location_ids)
        if !locations.nil?
          status 200
        else
          status 404
          return {}
        end
        render locations
      end

      # Create a location for the current driver
      # Needs address information to create
      desc 'Create a new location from a driver'
      params do
        requires :location, type: Hash do
          requires :street, type: String
          requires :city, type: String
          requires :state, type: String
          requires :zip, type: String
          optional :notes, type: String
        end
        requires :default_location, type: Hash do
          optional :default, type: Boolean, default: false
        end
      end
      post 'locations' do
        location = Location.new
        location.attributes = params[:location]
        location.location_must_be_found #Geocoder location search
        if location.errors.any?
          status 400
          return {error: location.errors.full_messages.to_sentence }
        end
        save_location = location
        location = location.save_or_touch
        if !location.nil?
          location_relationship = current_driver.location_relationships.where(location_id: location.id).first
          location_relationship ||= current_driver.location_relationships.new(location_id: location.id)

          default_location = current_driver.location_relationships.where(default: true).first
          if default_location && default_location != location_relationship && params[:default_location][:default]
            default_location.default = false
            default_location.save
          end
          location_relationship.default = params[:default_location][:default]
          location_relationship.save
          status 201
          return location
        else
          status 400
          return {error: save_location.errors.full_messages.to_sentence }
        end
      end

      # Update a location for a driver
      desc 'put a location from a driver'
      params do
        requires :id, type: Integer, desc: 'ID of location'
        optional :location, type: Hash do
          optional :street, type: String
          optional :city, type: String
          optional :state, type: String
          optional :zip, type: String
          optional :notes, type: String
        end
        optional :default_location, type: Hash do
          optional :default, type: Boolean, default: false
        end
      end
      put 'locations/:id' do
        # Find location to change
        begin
          old_location = Location.find(permitted_params[:id])
        rescue ActiveRecord::RecordNotFound
          status 404
          return {}
        end

        unless driver_owns_location(current_driver, old_location)
          status 401
          return {}
        end
        if LocationRelationship.where(location: permitted_params[:id]).count > 1
          new_location = Location.new(params[:location]) # We don't want to change the location address if someone else is using it already
          new_location.location_must_be_found
          if new_location.errors.any? # If Geolocation didn't find it
            status 400
            return {error: new_location.errors.full_messages.to_sentence }
          end
          save_success = new_location.save_or_touch
          unless save_success  # If save_or_touch fails
            status 400
            return {errors: new_location.errors.full_messages.to_sentence }
          end
          location_relationship = LocationRelationship.where(location: permitted_params[:id], driver_id: current_driver.id).first
          if params[:default_location]
            location_relationship.update(default: params[:default_location][:default], location: save_success) #updating l_r with his/her own location
          else
            location_relationship.update(location: save_success) #updating l_r with his/her own location
          end
          status 200
          return save_success
        else
          # update old location
          update_success = if params[:location].present?
                             old_location.update(params[:location])
                           else
                             true
                           end
          if update_success
            location_relationship2 = current_driver.location_relationships.find_by(location: old_location)
            if params[:default_location]
              default_location_relationship = current_driver.location_relationships.where(default: true).first

              if default_location_relationship && default_location_relationship != location_relationship2 && params[:default_location] && params[:default_location][:default]
                default_location_relationship.update(default: false)
              end
              location_relationship2.update(default: params[:default_location][:default])
            end
            old_location.reload
            render_value = old_location
            status 200
          else
            render_value = {error: old_location.errors.full_messages.to_sentence }
            status 400
          end
          render_value
        end
      end

      desc 'Delete an association between a driver and a location'
      params do
        requires :id, type: String, desc: 'ID of location'
      end
      delete 'locations/:id' do
        begin
          old_location = Location.find(permitted_params[:id])
        rescue ActiveRecord::RecordNotFound
          status 404
          return {}
        end

        if driver_owns_location(current_driver, old_location)
          LocationRelationship.find_by(location_id: permitted_params[:id],
                                       driver_id: current_driver.id).destroy
          if LocationRelationship.where(location: permitted_params[:id]).count == 0
            old_location.destroy
          end
          status 200
        else
          status 401
        end
        return {}
      end
    end
  end
end

private
def driver_owns_location(driver, location)
  location_ids = LocationRelationship.where(driver_id: driver.id).pluck(:location_id)
  location_ids.include?(location.id)
end
