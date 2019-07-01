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
    it "Sign up for availabilities" do 
     post '/api/v1/availabilities', headers: {"ACCEPT" => "application/json", "Token" => logintoken}, params: { 
         start_date: "02-01-2019",
         end_date: "05-03-2019", 
         start_time: "09-03-2019", 
         end_time: "10-02-2019", 
         is_recurring: true,
         location_id: "1"
     } 
     expect(response).to have_http_status(201)
     puts response.body
    end
  
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:driver) { FactoryBot.create(:driver, organization_id: organization.id) }
    let!(:location) { FactoryBot.create(:location) }
    let!(:schedule_window) { FactoryBot.create(:schedule_window, driver_id: driver.id, location_id: location.id) }
    it "update availabilities" do 
       put "/api/v1/availabilities/#{schedule_window.id}", headers: {"ACCEPT" => "application/json", "Token" => logintoken}, 
       params: { id: schedule_window.id} 
      expect(response).to have_http_status(200)
     puts response.body
    end
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:driver) { FactoryBot.create(:driver, organization_id: organization.id) }
    let!(:location) { FactoryBot.create(:location) }
    let!(:schedule_window) { FactoryBot.create(:schedule_window, driver_id: driver.id, location_id: location.id) }
     it "Gets the schedule_window" do
     get '/api/v1/availabilities', headers: {"ACCEPT" => "application/json", "Token" => logintoken},
     params: {start_date: "02-01-2019", end_date: "05-03-2019"}
     expect(response).to have_http_status(200)
     puts response.body
    end
    
    it "delete schedule_window" do 
     token = logintoken
     delete "/api/v1/availabilities/#{schedule_window.id}", headers: { "ACCEPT" => "application/json", "Token" => token}, 
     params: {id: schedule_window.id }
     expect(response).to have_http_status(200)
      puts response.body
    end
end