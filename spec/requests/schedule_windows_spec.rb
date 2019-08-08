require 'rails_helper'

RSpec.describe "Api::V1::Schedule_Windows", type: :request do
    def logintoken
       post '/api/v1/login', headers: {"ACCEPT" => "application/json" }, params: { email: "v1@sample.com", password: "password" }
       parsed_json = JSON.parse(response.body)
       parsed_json['json']['auth_token']
    end
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:driver) { FactoryBot.create(:driver, organization_id: organization.id) }
    let!(:schedule_window) { FactoryBot.create(:schedule_window, driver_id: driver.id) }
    let!(:location) { FactoryBot.create(:location) }
    let!(:headers) {  {"ACCEPT" => "application/json", "Token" => logintoken}
    }
    
    # Avariablities used for test below
    time = Time.now 
    start_date = time + 3.months 
    end_date = time + 5.months
    start_time = time + 2.hours
    end_time = time + 5.hours

   
    it "Creates a availabilities with recurring false " do 
        post '/api/v1/availabilities', headers: headers,  params: { 
            start_date: start_date,
            end_date: end_date, 
            start_time: start_time, 
            end_time: end_time, 
            is_recurring: false,
            location_id: location.id
            } 
          parsed_json = JSON.parse(response.body)
          expect(Time.parse(parsed_json['start_date'])).to eq(start_date.change(usec: 0))
          expect(Time.parse(parsed_json['end_date'])).to eq(end_date.change(usec: 0))
          expect(Time.parse(parsed_json['start_time'])).to eq(start_time.change(usec: 0))
          expect(Time.parse(parsed_json['end_time'])).to eq(end_time.change(usec: 0))
          expect(parsed_json['is_recurring']).to eq(false)
      end
     
     it "Creates availabilities with recurring true" do
        post '/api/v1/availabilities', headers: {"ACCEPT" => "application/json", "Token" => logintoken}, params: { 
            start_date: '2019-07-16',
            end_date: '2019-12-03', 
            start_time: '2019-07-16 14:00', 
            end_time: '2019-07-16 15:00', 
            is_recurring: true,
            location_id: location.id
          }
          
          recurring_pattern = RecurringPattern.first
          puts recurring_pattern.inspect
          parsed_json = JSON.parse(response.body)
          puts parsed_json
          expect(recurring_pattern.separation_count).to eq(0)
          expect(recurring_pattern.day_of_week).to eq(2)
          expect(recurring_pattern.week_of_month).to eq(nil)
          expect(recurring_pattern.month_of_year).to eq(nil)
          expect(recurring_pattern.type_of_repeating).to eq('weekly')
      end
      
      it 'Gets recurring schedule window that is true ' do
        schedule_window = FactoryBot.create(:schedule_window, 
        driver_id: driver.id,
        start_date: "2019-07-16",
        end_date: "2019-07-30",
        start_time: "2019-07-16, 2:00pm",
        end_time: "2019-07-16, 6:00pm",
        is_recurring: true,
        location_id: location.id
        )
        puts schedule_window.inspect
        FactoryBot.create(:recurring_pattern, schedule_window_id: schedule_window.id, day_of_week: 2 )
          get '/api/v1/availabilities', headers: headers
          parsed_json = JSON.parse(response.body)
          
          puts "START TIME"
           puts parsed_json['json'].map{|k| k['startDate'] }
           puts "END TIME"
           puts parsed_json['json'].map{|k| k['endTime'] }

            # expect(Time.parse(parsed_json['json'][0]['startDate']).strftime("%D")).to eq( "2019-07-16")
          # expect(Time.parse(parsed_json['end_date'])).to eq(end_date.change(usec: 0))
          # expect(Time.parse(parsed_json['start_time'])).to eq(start_time.change(usec: 0))
          # expect(Time.parse(parsed_json['end_time'])).to eq(end_time.change(usec: 0))
          # expect(parsed_json['is_recurring']).to eq(true)
      end
    
    it "Get schedule_window" do
        get '/api/v1/availabilities',  headers: headers
        expect(response).to have_http_status(200)
        expect(ScheduleWindow.count).to eq(1)
        parsed_json = JSON.parse(response.body)
    end
      
    it "Gets schedule_window by ID" do
        get "/api/v1/availabilities/window/#{schedule_window.id}", headers: headers
        expect(response).to have_http_status(200)
        parsed_json = JSON.parse(response.body)
        # puts parsed_json
        puts parsed_json['json'][0]["startDate"]
        # expect(parsed_json["json"][0]["startDate"]).to eq(startDate.change(usec: 0))
    end

      it "Updates the schedule_window" do
        put "/api/v1/availabilities/#{schedule_window.id}", headers: headers,
        params: { 
          start_date: start_date,
          end_date: end_date, 
          start_time: start_time, 
          end_time: end_time, 
          is_recurring: false,
          location_id: location.id
      } 
        parsed_json = JSON.parse(response.body)
        expect(Time.parse(parsed_json['start_date'])).to eq(start_date.change(usec: 0))
        expect(Time.parse(parsed_json['end_date'])).to eq(end_date.change(usec: 0))
        expect(Time.parse(parsed_json['start_time'])).to eq(start_time.change(usec: 0))
        expect(Time.parse(parsed_json['end_time'])).to eq(end_time.change(usec: 0))
        expect(parsed_json['is_recurring']).to eq(false)
        end
      
    it "Delete" do
        delete "/api/v1/availabilities/#{schedule_window.id}", headers: headers, 
        params: {id: schedule_window }
        parsed_json = JSON.parse(response.body)
        expect(parsed_json).to eq("sucess"=>true)
        expect(ScheduleWindow.count).to eq(0)
        expect(response).to have_http_status(200)
    end
  end