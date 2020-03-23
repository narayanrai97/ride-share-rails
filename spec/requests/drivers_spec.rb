require 'rails_helper'

RSpec.describe Api::V1::Drivers, type: :request do

    def logintoken
        post '/api/v1/login', headers: {"ACCEPT" => "application/json" }, params: { email: driver.email, password: "password" }
       parsed_json = JSON.parse(response.body)
       parsed_json['json']['auth_token']
    end

    let!(:organization) { FactoryBot.create(:organization) }
    let!(:driver) { FactoryBot.create(:driver, organization_id: organization.id) }
    let!(:driver2) { FactoryBot.create(:driver, first_name: "Phil", organization_id: organization.id,
    auth_token: "5678", token_created_at: Time.zone.now) }
    let!(:location) { FactoryBot.create(:location) }
    let!(:location_relationships) { LocationRelationship.create(driver_id: driver.id, location_id: location.id) }

    it 'driver login in' do
    post '/api/v1/login', headers: {"ACCEPT" => "application/json" }, params: { email: driver.email, password: "password" }
       expect(response).to have_http_status(201)
    end

    it 'Test password reset' do
    post '/api/v1/drivers/password_reset', headers: {"ACCEPT" => "application/json" },
    params: { email: driver.email}
       expect(response).to have_http_status(201)
       puts response.body
    end

    it 'Return a 404 when password reset email is not found' do
    post '/api/v1/drivers/password_reset', headers: {"ACCEPT" => "application/json" },
    params: { email: "jumping@gmail.com"}
       expect(response).to have_http_status(404)
       puts response.body
    end

    it "enrolls a driver" do
       post '/api/v1/drivers', headers: {"ACCEPT" => "application/json"},
       params: {driver: { email: "sample@sample.com", password: "password",
       first_name: "Bob", last_name: "Steve",
       phone: "3361234567", organization_id: organization.id,
       radius: 50, is_active: true
       }}

       expect(response).to have_http_status(201)
       parsed_json = JSON.parse(response.body)
       expect(parsed_json['driver']['email']).to eq('sample@sample.com')
       expect(parsed_json['driver']['first_name']).to eq('Bob')
       expect(parsed_json ['driver']['last_name']).to eq('Steve')
       expect(parsed_json['driver']['phone']).to eq('3361234567')
       expect(parsed_json['driver']['radius']).to eq(50)
       expect(parsed_json['driver']['is_active']).to eq(true)
    end

    # should recieve error code 400 when fields are missing
    it "will render error code when fields are missing" do
       post '/api/v1/drivers', headers: {"ACCEPT" => "application/json"},
       params: {driver: { email: "sample@sample.com", password: "password",
       first_name: "Frank",
        organization_id: organization.id,
       radius: 50, is_active: true
       }}
       expect(response).to have_http_status(400)
    end

    it 'update driver infomation ' do
       put '/api/v1/drivers', headers: {"ACCEPT" => "application/json", "Token" => logintoken },
       params:  {driver:
       { email: "sample@sample.com",
       password: "password",
       first_name: "Tom",
       last_name: "Martin",
       phone: "6152239090",
       organization_id: organization.id,
       radius: 50, is_active: true
       }}

       expect(response).to have_http_status(200)
       parsed_json = JSON.parse(response.body)
       expect(parsed_json['driver']['email']).to eq('sample@sample.com')
       expect(parsed_json['driver']['first_name']).to eq('Tom')
       expect(parsed_json ['driver']['last_name']).to eq('Martin')
       expect(parsed_json['driver']['phone']).to eq('6152239090')
       expect(parsed_json['driver']['radius']).to eq(50)
       expect(parsed_json['driver']['is_active']).to eq(true)

    end

    it 'returns a 400 error message when fields are not valid ' do
       put '/api/v1/drivers', headers: {"ACCEPT" => "application/json", "Token" => logintoken },
       params:  {driver:
       { email: "sample@sample.com", password: "password",
       first_name: "Tom", last_name: "Jumper",
       phone: "Rails", organization_id: organization.id,
       radius: 50, is_active: true
       }}
       expect(response).to have_http_status(400)
    end

    it "returns current drivers" do
       get "/api/v1/drivers", headers: { "ACCEPT" => "application/json", "Token" => logintoken }
      expect(response).to have_http_status(200)
    end

    it "returns a 400 when driver does not have a token" do
       get "/api/v1/drivers", headers: { "ACCEPT" => "application/json"}
       expect(response).to have_http_status(400)
    end

    it 'logout driver and destorys token' do
        token = logintoken
        delete '/api/v1/logout', headers: {"ACCEPT" => "application/json", 'Token' => logintoken}
        expect(response).to have_http_status(201)

        # this test makes sure that the token has been destory
        delete '/api/v1/logout', headers: {"ACCEPT" => "application/json", 'Token' =>   token}
        expect(response).to have_http_status(401)

        delete '/api/v1/logout', headers: {"ACCEPT" => "application/json"}
        expect(response).to have_http_status(401)
    end
end
