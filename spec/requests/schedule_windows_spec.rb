require 'rails_helper'

RSpec.describe "Api::V1::Schedule_Windows", type: :request do
    def logintoken
       post '/api/v1/login', headers: {"ACCEPT" => "application/json" }, params: { 
       email: recurring_pattern.schedule_window.driver.email,
       password: "password" }
       parsed_json = JSON.parse(response.body)
       parsed_json['json']['auth_token']
       
    end
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:driver) { FactoryBot.create(:driver, organization_id: organization.id) }
    let!(:recurring_pattern) { FactoryBot.create(:recurring_weekly_pattern) }
    let!(:location) { FactoryBot.create(:location) }
    let!(:headers) {  {"ACCEPT" => "application/json", "Token" => logintoken}
    }
    
    it "Creates a availabilities with recurring false " do 
        post '/api/v1/availabilities', headers: headers,  params: { 
            start_time: "09/01/2019 1400", 
            end_time: "09/01/2019 1600", 
            is_recurring: false,
            location_id: location.id
            } 
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['start_time']).to eq("2019-01-09T00:00:00.000Z")
          expect(parsed_json['end_time']).to eq("2019-01-09T00:00:00.000Z")
          expect(parsed_json['is_recurring']).to eq(false)
      end
     
     it "Creates availabilities with recurring true" do
        post '/api/v1/availabilities', headers: headers, params: { 
            start_date: '2019-10-01',
            end_date: '2019-12-31', 
            start_time: '2019-10-01 14:00', 
            end_time: '2019-10-01 17:00', 
            is_recurring: true,
            location_id: location.id
          }
          expect(recurring_pattern.separation_count).to eq(0)
          expect(recurring_pattern.day_of_week).to eq(6)
          expect(recurring_pattern.week_of_month).to eq(nil)
          expect(recurring_pattern.month_of_year).to eq(nil)
          expect(recurring_pattern.type_of_repeating).to eq('weekly')
      end
      
      it 'Gets recurring schedule window that is true ' do
          get '/api/v1/availabilities', headers: headers, params: {
              start: "2019-08-27",
              'end': '2019-09-21',
              }
          parsed_json = JSON.parse(response.body)

          # check that start times are correct
          startTime = parsed_json['json'].map{|k| k["startTime"] }
          expect(startTime).to eq(["2019-09-07 14:00", "2019-09-14 14:00", "2019-09-21 14:00"])
          
          #check that end times are correct
          endTime = parsed_json['json'].map{|k| k['endTime'] }
          expect(endTime).to eq(["2019-09-07 16:00", "2019-09-14 16:00", "2019-09-21 16:00"])

  
      end
    
    # it "Get schedule_window" do
    #     get '/api/v1/availabilities',  headers: headers
    #     expect(response).to have_http_status(200)
    #     expect(ScheduleWindow.count).to eq(1)
    #     parsed_json = JSON.parse(response.body)
    # end
      
    # it "Gets schedule_window by ID" do
    #     get "/api/v1/availabilities/window/#{schedule_window.id}", headers: headers
    #     expect(response).to have_http_status(200)
    #     parsed_json = JSON.parse(response.body)
    #     # puts parsed_json
    #     puts parsed_json['json'][0]["startDate"]
    #     # expect(parsed_json["json"][0]["startDate"]).to eq(startDate.change(usec: 0))
    # end

    #   it "Updates the schedule_window" do
    #     put "/api/v1/availabilities/#{schedule_window.id}", headers: headers,
    #     params: { 
    #       start_date: start_date,
    #       end_date: end_date, 
    #       start_time: start_time, 
    #       end_time: end_time, 
    #       is_recurring: false,
    #       location_id: location.id
    #   } 
    #     parsed_json = JSON.parse(response.body)
    #     expect(Time.parse(parsed_json['start_date'])).to eq(start_date.change(usec: 0))
    #     expect(Time.parse(parsed_json['end_date'])).to eq(end_date.change(usec: 0))
    #     expect(Time.parse(parsed_json['start_time'])).to eq(start_time.change(usec: 0))
    #     expect(Time.parse(parsed_json['end_time'])).to eq(end_time.change(usec: 0))
    #     expect(parsed_json['is_recurring']).to eq(false)
    #     end
      
    # it "Delete" do
    #     delete "/api/v1/availabilities/#{schedule_window.id}", headers: headers, 
    #     params: {id: schedule_window }
    #     parsed_json = JSON.parse(response.body)
    #     expect(parsed_json).to eq("sucess"=>true)
    #     expect(ScheduleWindow.count).to eq(0)
    #     expect(response).to have_http_status(200)
    # end
  end