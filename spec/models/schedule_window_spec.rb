require 'rails_helper'

RSpec.describe ScheduleWindow, type: :model do

    describe "Validations" do
      it "expects to validate start date cannot be later than end date" do
        window =  build(:schedule_window, is_recurring: true, start_date: '2019-10-01', end_date: '2019-09-01')
        expect(window.valid?).to be_falsey
      end

       it "expects to validate start time cannot be later than end time" do
        window =  build(:schedule_window, is_recurring: true, start_time: '2019-09-02 1600', end_time: '2019-09-02 1300')
        expect(window.valid?).to be_falsey
      end

      it "expects to validate start date cannot be later than start time" do
        window = build(:schedule_window, is_recurring: true, start_date: '2019-09-01', start_time: '2019-08-01 12:00')
        expect(window.valid?).to be_falsey
      end

      it "expects to validate end date cannot be before end time" do
        window =   build(:schedule_window, is_recurring: true, end_date: '2019-10-02 1600', end_time: '2019-10-12 1400')
        expect(window.valid?).to be_falsey
      end
    end

    describe "Associations" do
      it { is_expected.to belong_to(:driver) }
      it { is_expected.to have_one(:recurring_pattern) }
      it { is_expected.to belong_to(:location) }
    end

    describe 'Cannot be in the past' do
      it "expects to validate that start time cannot be in the past" do
        subject.start_time = "2019-07-01"
        subject.valid?  # run validations
        expect(subject.errors[:start_time]).to include('cannot be in the past')
      end

      it "expects to validate that end time cannot be in the past" do
        subject.end_time = "2019-07-01"
        subject.valid?
        expect(subject.errors[:end_time]).to include('cannot be in the past')
      end

      it "expects to validate that start date cannot be in the past" do
        subject.start_date = "2019-07-01"
        subject.valid?  # run validations
        expect(subject.errors[:start_date]).to include('cannot be in the past')
      end

      it "expects to validate that end date cannot be in the past" do
        subject.end_date = "2019-07-01"
        subject.valid?
        expect(subject.errors[:end_date]).to include('cannot be in the past')
      end
    end

    describe 'Cannot be overlapped' do
      it "expects to validate that end time cannot be before start time" do
        subject.start_time = "2019-07-01 9:00am"
        subject.end_time = "2019-07-01 9:00am"
        subject.valid?  # run validations
        expect(subject.valid?).to be_falsey
      end

      it "expects to validate that end date cannot be before start date" do
        subject.start_time = "2019-07-01"
        subject.end_time = "2019-07-01"
        subject.valid?  # run validations
        expect(subject.valid?).to be_falsey
      end
    end

      describe 'recurring weekly' do
        begin_time = DateTime.now. +  1.day + 1.hour
        let(:recurring_pattern) { create(:recurring_weekly_pattern, begin_time: begin_time ) }

       describe 'recurring weekly' do
        let(:recurring_pattern) { create(:recurring_weekly_pattern) }

        it "expects to return weekly events" do
          start_date = Date.parse('2025-09-11')
          end_date = Date.parse('2025-09-25')

          events = recurring_pattern.schedule_window.recurring_weekly(start_date, end_date)

          # check correct number of events
          expect(events.length).to eq(2)

          # check that start times are correct
          start_times = events.map{|k| k[:startTime] }
          expect(start_times).to eq(['2025-09-20 14:00', '2025-09-13 14:00'])

          # check that end times are correct
          end_times = events.map{|k| k[:endTime] }
          # expect(end_times).to eq(['2025-09-20 16:00', '2025-09-13 16:00'])
        end

        it "expects to return an empty [] when query is after the date range of the schedule window" do
          query_start_date = Date.parse('2025-10-20')
          query_end_date = Date.parse('2025-11-27')

          events = recurring_pattern.schedule_window.recurring_weekly(query_start_date, query_end_date)

          #check that array is empty
          expect(events).to eq([])
      end

       it "expects to return an empty [] when query is before the date range of the schedule window" do
          query_start_date = Date.parse('2025-08-01')
          query_end_date = Date.parse('2025-08-31')

          events = recurring_pattern.schedule_window.recurring_weekly(query_start_date, query_end_date)

          #check that array is empty
          expect(events).to eq([])
        end

        it "expects to return [] of events when query is before the schedule window start date but in range of the end date" do
          query_start_date = Date.parse("2025-08-01")
          query_end_date = Date.parse("2025-09-21")

          events = recurring_pattern.schedule_window.recurring_weekly(query_start_date, query_end_date)

          #check correct number of events
          expect(events.length).to eq(3)

          # check that start times are correct
          start_times = events.map{|k| k[:startTime] }
          expect(start_times).to eq(["2025-09-20 14:00","2025-09-13 14:00","2025-09-06 14:00"])


          # check that end times are correct
          end_dates = events.map{|k| k[:endTime] }
          expect(end_dates).to eq(["2025-09-20 16:00", "2025-09-13 16:00", "2025-09-06 16:00"])
        end

        it "expects to return an [] of events when query is in range of the schedule window start date but past the end date" do
          query_start_date = Date.parse("2025-10-01")
          query_end_date = Date.parse("2025-11-21")

          events = recurring_pattern.schedule_window.recurring_weekly(query_start_date, query_end_date)

          #check correct number of events
          expect(events.length).to eq(3)

          # check that start times are correct
          start_times = events.map{|k| k[:startTime] }
          expect(start_times).to eq(["2025-10-18 14:00","2025-10-11 14:00","2025-10-04 14:00"])


          # check that end times are correct
          end_dates = events.map{|k| k[:endTime] }
          expect(end_dates).to eq(["2025-10-18 16:00","2025-10-11 16:00","2025-10-04 16:00"])
        end

        it "expects return and [] of events when query is before schedule window start_date and range is pass the end date" do
          query_start_date = Date.parse("2025-08-01")
          query_end_date = Date.parse("2025-11-30")

          events = recurring_pattern.schedule_window.recurring_weekly(query_start_date, query_end_date)

          # check that start times are correct
          expect(events.length).to eq(7)

          # check that start times are correct
          start_times = events.map{|k| k[:startTime] }
          expect(start_times).to eq(["2025-10-18 14:00","2025-10-11 14:00","2025-10-04 14:00", "2025-09-27 14:00",
          "2025-09-20 14:00", "2025-09-13 14:00", "2025-09-06 14:00" ])


          # check that end times are correct
          end_times = events.map{|k| k[:endTime] }
           expect(end_times).to  eq(["2025-10-18 16:00","2025-10-11 16:00","2025-10-04 16:00", "2025-09-27 16:00",
          "2025-09-20 16:00", "2025-09-13 16:00", "2025-09-06 16:00" ])
        end
      end
    end
end
