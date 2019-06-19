require 'rails_helper'

RSpec.describe Api::VehiclesController, type: :request do
    let!(:organization) { FactoryBot.create(:organization) }
    #Created a token to by pass login but had to include
    #token_created_at in the last day so it would function
    let!(:driver) { FactoryBot.create(:driver, organization_id: 2,
       auth_token: "1234",token_created_at: Time.zone.now) }
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

end
