require 'rails_helper'

RSpec.describe Api::DriversController, type: :request do
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:driver) { FactoryBot.create(:driver, organization_id: organization.id) }
    it 'driver login in' do
    post '/api/v1/login', headers: {"ACCEPT" => "application/json" }, params: { email: "v1@sample.com", password: "password" }
       
       expect(response).to have_http_status(201) 
        puts response.body
    end
    it "enrolls a driver" do 
       post '/api/v1/drivers', headers: {"ACCEPT" => "application/json"}, params: {driver: { email: "sample@sample.com", password: "password",
       first_name: "Bob", last_name: "Steve", phone: "3361234567", organization_id: organization.id, radius: 50, is_active: true
       }}
       expect(response).to have_http_status(200)
       parsed_json = JSON.parse(response.body)
       puts parsed_json
       expect(parsed_json['driver']['email']).to eq('sample@sample.com')
       expect(parsed_json['driver']['first_name']).to eq('Bob')
       expect(parsed_json ['driver']['last_name']).to eq('Steve')
       expect(parsed_json['driver']['phone']).to eq('3361234567')
       expect(parsed_json['driver']['radius']).to eq(50)
       expect(parsed_json['driver']['is_active']).to eq(true)
    end
end
