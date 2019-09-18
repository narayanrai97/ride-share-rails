require 'rails_helper'

RSpec.describe Api::V1::Vehicles, type: :request do
    #Drivers require a organization to assosiate with
    let!(:organization) { FactoryBot.create(:organization) }
    #Created a token to by pass login but had to include
    #token_created_at in the last day so it would function
    let!(:driver) { FactoryBot.create(:driver, organization_id: organization.id,
       auth_token: "1234",token_created_at: Time.zone.now) }
    let!(:driver2) { FactoryBot.create(:driver, organization_id: organization.id,
       auth_token: "5678",token_created_at: Time.zone.now) }   
    let!(:vehicle){FactoryBot.create(:vehicle, driver_id: driver.id, car_year: 2017)}
    let!(:vehicle1){FactoryBot.create(:vehicle, driver_id: driver.id)}
    let!(:vehicle2){FactoryBot.create(:vehicle, driver_id: driver2.id, car_make: "Chevy", car_color: "Black")}


    #Created a vehicle with the currently logged in driver
    it 'will create a vehicle with logged in user' do

      post '/api/v1/vehicles', headers: {"ACCEPT" => "application/json",  "Token" => "1234"},
       params: {vehicle: {car_make: "Chevorlet",
        car_model: "Impala",
        car_year: 2010,
        car_color: "Silver",
        car_plate: "VZW1212",
        insurance_provider: "Geico",
        insurance_start: "2019/3/11",
        insurance_stop: "2020/3/11",
        seat_belt_num: 5}
        }
        expect(response).to have_http_status(201)
        parsed_json = JSON.parse(response.body)
        #puts parsed_json
        expect(parsed_json['vehicle']['car_make']).to eq('Chevorlet')
        expect(parsed_json['vehicle']['car_year']).to eq(2010)
        expect(parsed_json['vehicle']['car_color']).to eq('Silver')
        expect(parsed_json['vehicle']['car_plate']).to eq('VZW1212')
        expect(parsed_json['vehicle']['insurance_provider']).to eq('Geico')
        #Dates a formatted when they are accepted so appear slightly different than above
        expect(parsed_json['vehicle']['insurance_start']).to eq('2019-03-11')
        expect(parsed_json['vehicle']['insurance_stop']).to eq('2020-03-11')
        expect(parsed_json['vehicle']['seat_belt_num']).to eq(5)
    end
    
     it 'will return error 400 if fields are missing or not correct. Will not save' do
      post '/api/v1/vehicles', headers: {"ACCEPT" => "application/json",  "Token" => "1234"},
       params: {vehicle: {car_make: "Chevorlet",
        car_model: "Impala",
        car_year: "Rails Rule",
        car_plate: "VZW1212",
        insurance_provider: "Geico",
        insurance_start: "2019/3/11",
        insurance_stop: "2020/3/11",
        seat_belt_num: 5}
        }
        expect(response).to have_http_status(400)
      end
    
    #API response of all vehicles of  a driver
    it 'will generate all vehicles of user' do

      get '/api/v1/vehicles', headers: {"ACCEPT" => "application/json",  "Token" => "1234"}

        expect(response).to have_http_status(200)
        parsed_json = JSON.parse(response.body)
  
        #Needs Index [0] because returns 2 vehicles
        expect(parsed_json['vehicle'][0]['car_make']).to eq('Nissan')
        expect(parsed_json['vehicle'][0]['car_year']).to eq(2017)
        expect(parsed_json['vehicle'][0]['car_color']).to eq('Silver')
        expect(parsed_json['vehicle'][0]['car_plate']).to eq('ZQWOPQ')
        expect(parsed_json['vehicle'][0]['insurance_provider']).to eq('Geico')
        #Dates a formatted when they are accepted so appear slightly different than above
        expect(parsed_json['vehicle'][0]['insurance_start'].to_date).to eq(Time.now.to_date)
        expect(parsed_json['vehicle'][0]['insurance_stop'].to_date).to eq((Time.now + 6.months).to_date)
        expect(parsed_json['vehicle'][0]['seat_belt_num']).to eq(4)
        
    end
    
    it 'return 404 error code if its not current driver' do
      Vehicle.destroy_all
      get '/api/v1/vehicles', headers: {"ACCEPT" => "application/json",  "Token" => "5678"}
        expect(response).to have_http_status(404)
      end
      
    #Returns information about a specific vehicle based on param of vehicle_id,
    #Has to be owned by driver
    it 'will return one vehicle based on id' do
      get '/api/v1/vehicle', headers: {"ACCEPT" => "application/json",  "Token" => "1234"}, params: {id: vehicle.id }
      parsed_json = JSON.parse(response.body)
      expect(parsed_json['vehicle']['car_make']).to eq('Nissan')
      expect(parsed_json['vehicle']['car_year']).to eq(2017)
      expect(parsed_json['vehicle']['car_color']).to eq('Silver')
      expect(parsed_json['vehicle']['car_plate']).to eq('ZQWOPQ')
      expect(parsed_json['vehicle']['insurance_provider']).to eq('Geico')
      #Dates a formatted when they are accepted so appear slightly different than above
      expect(parsed_json['vehicle']['insurance_start'].to_date).to eq(Time.now.to_date)
      expect(parsed_json['vehicle']['insurance_stop'].to_date).to eq((Time.now + 6.months).to_date)
      expect(parsed_json['vehicle']['seat_belt_num']).to eq(4)
    end

    #Test update vehicle method
    it 'will update a vehicle of the logged in user' do

      put '/api/v1/vehicles', headers: {"ACCEPT" => "application/json",  "Token" => "1234"},
        params: {vehicle: {id: vehicle.id, car_make: "Chevorlet",
          car_model: "Impala",
          car_year: 2010,
          car_color: "Silver",
          car_plate: "VZW1212",
          insurance_provider: "Geico",
          insurance_start: "2019/3/11",
          insurance_stop: "2020/3/11",
          seat_belt_num: 5}
        }
        expect(response).to have_http_status(201)
        parsed_json = JSON.parse(response.body)
        expect(parsed_json['vehicle']['car_make']).to eq('Chevorlet')
        expect(parsed_json['vehicle']['car_year']).to eq(2010)
        expect(parsed_json['vehicle']['car_color']).to eq('Silver')
        expect(parsed_json['vehicle']['car_plate']).to eq('VZW1212')
        expect(parsed_json['vehicle']['insurance_provider']).to eq('Geico')
        #Dates a formatted when they are accepted so appear slightly different than above
        expect(parsed_json['vehicle']['insurance_start']).to eq('2019-03-11')
        expect(parsed_json['vehicle']['insurance_stop']).to eq('2020-03-11')
        expect(parsed_json['vehicle']['seat_belt_num']).to eq(5)
    end
    
     it "returns a 404 error when not current driver" do
    put '/api/v1/vehicles', headers: {"ACCEPT" => "application/json",  "Token" => "5678"},
        params: {vehicle: {id: vehicle.id, car_make: "Chevorlet",
          car_model: "Impala",
          car_year: 2010,
          car_color: "Silver",
          car_plate: "VZW1212",
          insurance_provider: "Geico",
          insurance_start: "2019/3/11",
          insurance_stop: "2020/3/11",
          seat_belt_num: 5}
        }
        expect(response).to have_http_status(404)
    end

    #Test deleting a vehicle using vehicle id.
    #Vehicle has to belong to Driver

    it 'will delete vehicle based on id' do
      delete '/api/v1/vehicles', headers: {"ACCEPT" => "application/json",  "Token" => "1234"}, params: {id: vehicle1.id }
       parsed_json = JSON.parse(response.body)
       expect(parsed_json['sucess']).to eq(true)
       expect(response).to have_http_status(200)
       expect(Vehicle.count).to eq(2)
    end
    
     it 'will return 404 error when vehicle does not belong to driver.' do
      delete '/api/v1/vehicles', headers: {"ACCEPT" => "application/json",  "Token" => "5678"}, params: {id: vehicle.id }
      expect(response).to have_http_status(404)
      #Comment to see what comes back
    end

end
