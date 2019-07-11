require 'rails_helper'

RSpec.describe "Api::V1::Schedule_Windows", type: :request do
    def logintoken
       post '/api/v1/login', headers: {"ACCEPT" => "application/json" }, params: { email: "v1@sample.com", password: "password" }
       parsed_json = JSON.parse(response.body)
       parsed_json['json']['auth_token']
    end
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:driver) { FactoryBot.create(:driver, organization_id: organization.id) }
    let!(:location) { FactoryBot.create(:location) }
    let!(:schedule_window) { FactoryBot.create(:schedule_window, driver_id: driver.id) }
    
    time = Time.now 
    start_date = time + 3.months 
    end_date = time + 5.months
    start_time = time + 2.hours
    end_time = time + 5.hours

   
    it "creates a availabilities with recurring false " do 
     post '/api/v1/availabilities', headers: {"ACCEPT" => "application/json", "Token" => logintoken}, params: { 
         start_date: start_date,
         end_date: end_date, 
         start_time: start_time, 
         end_time: end_time, 
         is_recurring: false,
         location_id: location.id
     } 
       parsed_json = JSON.parse(response.body)
       expect(parsed_json.count).to eq(8)
       expect(Time.parse(parsed_json['start_date'])).to eq(start_date.change(usec: 0))
       expect(Time.parse(parsed_json['end_date'])).to eq(end_date.change(usec: 0))
       expect(Time.parse(parsed_json['start_time'])).to eq(start_time.change(usec: 0))
       expect(Time.parse(parsed_json['end_time'])).to eq(end_time.change(usec: 0))
       expect(parsed_json['is_recurring']).to eq(false)
      end
     
     it "create availabilities with recurring true" do
     post '/api/v1/availabilities', headers: {"ACCEPT" => "application/json", "Token" => logintoken}, params: { 
         start_date: start_date,
         end_date: end_date, 
         start_time: start_time, 
         end_time: end_time, 
         is_recurring: true,
         location_id: location.id
     } 
       parsed_json = JSON.parse(response.body)
       expect(parsed_json.count).to eq(8)
       expect(Time.parse(parsed_json['start_date'])).to eq(start_date.change(usec: 0))
       expect(Time.parse(parsed_json['end_date'])).to eq(end_date.change(usec: 0))
       expect(Time.parse(parsed_json['start_time'])).to eq(start_time.change(usec: 0))
       expect(Time.parse(parsed_json['end_time'])).to eq(end_time.change(usec: 0))
       expect(parsed_json['is_recurring']).to eq(true)
      end
    
     it "get schedule_window" do
      get '/api/v1/availabilities', headers: {"ACCEPT" => "application/json", "Token" => logintoken}
      expect(response).to have_http_status(200)
      parsed_json = JSON.parse(response.body)
     end
      
     it "gets schedule_window by ID" do
      get "/api/v1/availabilities/window/#{schedule_window.id}", headers: {"ACCEPT" => "application/json", "Token" => logintoken},
      params: { id: 6 }
      parsed_json = JSON.parse(response.body)
      expect(response).to have_http_status(200)
     end

       it "updates the schedule_window" do
         put "/api/v1/availabilities/#{schedule_window.id}", headers: {"ACCEPT" => "application/json", "Token" => logintoken}, 
         params: { 
           start_date: start_date,
           end_date: end_date, 
           start_time: start_time, 
           end_time: end_time, 
           is_recurring: false,
           location_id: location.id
       } 
         parsed_json = JSON.parse(response.body)
         expect(parsed_json.count).to eq(8)
         expect(Time.parse(parsed_json['start_date'])).to eq(start_date.change(usec: 0))
         expect(Time.parse(parsed_json['end_date'])).to eq(end_date.change(usec: 0))
         expect(Time.parse(parsed_json['start_time'])).to eq(start_time.change(usec: 0))
         expect(Time.parse(parsed_json['end_time'])).to eq(end_time.change(usec: 0))
         expect(parsed_json['is_recurring']).to eq(false)
        end
      
     it "delete" do
      delete "/api/v1/availabilities/#{schedule_window.id}", headers: { "ACCEPT" => "application/json", "Token" => logintoken}, 
      params: {id: schedule_window }
      parsed_json = JSON.parse(response.body)
      expect(response).to have_http_status(200)
     end
  end