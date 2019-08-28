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
    let!(:headers)  { {"ACCEPT" => "application/json", "Token" => logintoken} }
    
    
    it "Creates a availabilities with recurring false " do 
        post '/api/v1/availabilities', headers: headers,  params: { 
            start_date: "2025-09-01",
            start_time: "2025-09-01 14:00", 
            end_time: "2025-09-01 16:00",
            end_date: "2025-09-02",
            is_recurring: false,
            location_id: location.id
            } 
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['schedule_window']['start_time']).to eq("2025-09-01T14:00:00.000Z")
          expect(parsed_json['schedule_window']['end_time']).to eq("2025-09-01T16:00:00.000Z")
          expect(parsed_json['schedule_window']['is_recurring']).to eq(false)
          expect(response).to have_http_status(201)
      end
      
      # This test should return a 401, since start time and end_time can not be after the start and end dates.
      it "returns a error message when endate is before end time" do 
        post '/api/v1/availabilities', headers: headers,  params: { 
            start_date: "2025-10-03",
            start_time: "2025-09-22 14:00", 
            end_time: "2025-10-22 16:00",
            end_date: "2025-10-15",
            is_recurring: true,
            location_id: location.id
            } 
          parsed_json = JSON.parse(response.body)
          expect(response).to have_http_status(404)
          
      end
     
     it "Creates availabilities with recurring true" do
        post '/api/v1/availabilities', headers: headers, params: { 
            start_date: '2025-10-01',
            end_date: '2025-12-31', 
            start_time: '2025-10-01 14:00', 
            end_time: '2025-10-01 17:00', 
            is_recurring: true,
            location_id: location.id
          }
          parsed_json = JSON.parse(response.body)
          expect(parsed_json['schedule_window']['start_date']).to eq("2025-10-01T00:00:00.000Z")
          expect(parsed_json['schedule_window']['end_date']).to eq("2025-12-31T00:00:00.000Z")
          expect(parsed_json['schedule_window']['start_time']).to eq("2025-10-01T14:00:00.000Z")
          expect(parsed_json['schedule_window']['end_time']).to eq("2025-10-01T17:00:00.000Z")
          expect(parsed_json['schedule_window']['is_recurring']).to eq(true)
          expect(response).to have_http_status(201)
      end
      
      it 'Gets recurring schedule window that is true ' do
          get '/api/v1/availabilities', headers: headers, params: {
              start: "2025-08-26",
              'end': '2025-09-20',
              }
          parsed_json = JSON.parse(response.body)
          # check that start times are correct
          startTime = parsed_json['json'].map{|k| k["startTime"] }
          expect(startTime).to eq(["2025-09-06 14:00", "2025-09-13 14:00", "2025-09-20 14:00"])
          
          #check that end times are correct
          endTime = parsed_json['json'].map{|k| k['endTime'] }
          expect(endTime).to eq(["2025-09-06 16:00", "2025-09-13 16:00", "2025-09-20 16:00"])
          expect(response).to have_http_status(200)
      end
      
    it "Gets schedule_window by ID" do
        get "/api/v1/availabilities/window/#{recurring_pattern.schedule_window.id}", headers: headers, params: {
            start: "2025-08-26",
            'end': "2025-09-20",
        }
            parsed_json = JSON.parse(response.body)
            # check that start times are correct
             startTime = parsed_json['json'].map{|k| k["startTime"] }
             expect(startTime).to eq(["2025-09-20 14:00", "2025-09-13 14:00", "2025-09-06 14:00"])

            #check that end times are correct
            endTime = parsed_json['json'].map{|k| k['endTime'] }
            expect(endTime).to eq(["2025-09-20 16:00", "2025-09-13 16:00", "2025-09-06 16:00"])
            expect(response).to have_http_status(200)
    end

        it "Updates the schedule_window" do
        put "/api/v1/availabilities/#{recurring_pattern.schedule_window.id}", headers: headers,
        params: { 
          start_date: "2025-09-01",
          end_date: "2025-10-21", 
          start_time: "2025-09-01 15:00", 
          end_time: "2025-09-01 17:00", 
          is_recurring: true,
          location_id: location.id
      } 
        parsed_json = JSON.parse(response.body)
        
        expect(parsed_json['schedule_window']["start_date"]).to eq("2025-09-01T00:00:00.000Z")
        expect(parsed_json['schedule_window']["end_date"]).to eq("2025-10-21T00:00:00.000Z")
        expect(parsed_json['schedule_window']["start_time"]).to eq("2025-09-01T15:00:00.000Z")
        expect(parsed_json['schedule_window']["end_time"]).to eq("2025-09-01T17:00:00.000Z")
        expect(parsed_json['schedule_window']["is_recurring"]).to eq(true)
        expect(response).to have_http_status(202)
        end
        
        # this test should recieve a 400 error code. Dates can not be in the past
        it "returns and error code when date is in the past" do
        put "/api/v1/availabilities/#{recurring_pattern.schedule_window.id}", headers: headers,
        params: { 
          start_date: "2000-10-01",
          end_date: "2000-10-21", 
          start_time: "2000-09-01 15:00", 
          end_time: "2000-09-01 17:00", 
          is_recurring: false,
          location_id: location.id
      } 
        parsed_json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        end
      
    it "Delete" do
        delete "/api/v1/availabilities/#{recurring_pattern.schedule_window.id}", headers: headers
        expect(ScheduleWindow.count).to eq(0)
    end
  end