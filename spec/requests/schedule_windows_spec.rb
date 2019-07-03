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
    it "Sign up for availabilities, get all availabilities, update and delete " do 
     post '/api/v1/availabilities', headers: {"ACCEPT" => "application/json", "Token" => logintoken}, params: { 
         start_date: "09-01-2019",
         end_date: "10-03-2019", 
         start_time: "07-03-2019, 2:00 pm", 
         end_time: "07-03-2019, 8:00 pm", 
         is_recurring: false,
         location_id: location.id
     } 
     expect(response).to have_http_status(201)
     parsed_json = JSON.parse(response.body)
       puts parsed_json
       expect(parsed_json['start_date']).to eq('2019-01-09T00:00:00.000Z')
       expect(parsed_json['end_date']).to eq('2019-03-10T00:00:00.000Z')
       expect(parsed_json ['start_time']).to eq('2019-03-07T14:00:00.000Z')
       expect(parsed_json['end_date']).to eq('2019-03-10T00:00:00.000Z')
       expect(parsed_json['is_recurring']).to eq(false)

    
     post '/api/v1/availabilities', headers: {"ACCEPT" => "application/json", "Token" => logintoken}, params: { 
         start_date: "10-01-2019",
         end_date: "11-03-2019", 
         start_time: "07-03-2019, 2:00 pm", 
         end_time: "07-03-2019, 8:00 pm", 
         is_recurring: false,
         location_id: location.id
     } 
     expect(response).to have_http_status(201)
     puts response.body
     
   
    post '/api/v1/availabilities', headers: {"ACCEPT" => "application/json", "Token" => logintoken}, params: { 
         start_date: "11-01-2019",
         end_date: "12-03-2019", 
         start_time: "011-03-2019, 5:00 pm", 
         end_time: "011-03-2019, 9:00 pm", 
         is_recurring: true,
         location_id: location.id
     }
     expect(response).to have_http_status(201)
     puts response.body
    
 
     get '/api/v1/availabilities', headers: {"ACCEPT" => "application/json", "Token" => logintoken},
     params: {start: "07-03-2019", end: "07-03-2019"}
     expect(response).to have_http_status(200)
     puts response.body
        parsed_json = JSON.parse(response.body)
        window_id = parsed_json['json'][0]['eventId']

       put "/api/v1/availabilities/#{window_id}", headers: {"ACCEPT" => "application/json", "Token" => logintoken}, 
       params: { 
         start_date: "02-01-2019",
         end_date: "05-03-2019", 
         start_time: "07-03-2019, 3:00 pm", 
         end_time: "07-03-2019, 8:00 pm", 
         is_recurring: false,
         location_id: location.id
       } 
      expect(response).to have_http_status(200)
     puts response.body
   
     delete "/api/v1/availabilities/#{window_id}", headers: { "ACCEPT" => "application/json", "Token" => logintoken}, 
     params: {id: window_id }
     expect(response).to have_http_status(200)
      puts response.body
    
 end
 
 end