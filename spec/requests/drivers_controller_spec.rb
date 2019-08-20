require 'rails_helper'

RSpec.describe Api::V1::Drivers, type: :request do
    
    def logintoken
<<<<<<< HEAD
        post '/api/v1/login', headers: {"ACCEPT" => "application/json" }, 
        params: { email: driver.email, password: "password" }
=======
        post '/api/v1/login', headers: {"ACCEPT" => "application/json" }, params: { email: driver.email, password: "password" }
>>>>>>> master
       parsed_json = JSON.parse(response.body)
       parsed_json['json']['auth_token']
    end
    
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:driver) { FactoryBot.create(:driver, organization_id: organization.id) }
<<<<<<< HEAD
    let!(:headers) {  {"ACCEPT" => "application/json", "Token" => logintoken} }
    
    it 'driver login in' do
       post '/api/v1/login', headers: headers, params: { email: driver.email, password: "password" }
=======
    
    it 'driver login in' do
    post '/api/v1/login', headers: {"ACCEPT" => "application/json" }, params: { email: driver.email, password: "password" }
>>>>>>> master
       expect(response).to have_http_status(201)
    end
    
    it "enrolls a driver" do
<<<<<<< HEAD
       post '/api/v1/drivers', headers: headers, 
       params: {driver: { email: "sample@sample.com", password: "password",
       first_name: "Bob", last_name: "Steve", 
       phone: "3361234567", 
       organization_id: organization.id, radius: 50, is_active: true
=======
       post '/api/v1/drivers', headers: {"ACCEPT" => "application/json"}, 
       params: {driver: { email: "sample@sample.com", password: "password",
       first_name: "Bob", last_name: "Steve", 
       phone: "3361234567", organization_id: organization.id,
       radius: 50, is_active: true
>>>>>>> master
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
    
    it 'update driver infomation ' do
<<<<<<< HEAD

       put "/api/v1/drivers", headers: headers, params: 
       {driver: { email: "sample@sample.com", password: "password",
       first_name: "Bob", last_name: "Martin",
       phone: "7180987654", 
       organization_id: organization.id, radius: 50, is_active: true
=======
       put '/api/v1/drivers', headers: {"ACCEPT" => "application/json", "Token" => logintoken }, 
       params:  {driver: 
       { email: "sample@sample.com", password: "password",
       first_name: "Bob", last_name: "Martin",
       phone: "7180987654", organization_id: organization.id, 
       radius: 50, is_active: true
>>>>>>> master
       }}
       
       expect(response).to have_http_status(200)
       
    end
    
    it 'logout driver and destorys token' do
<<<<<<< HEAD
        delete '/api/v1/logout', headers: headers
        expect(response).to have_http_status(201)

        # this test makes sure that the token has been destory
        delete '/api/v1/logout', headers: headers
=======
        token = logintoken
        delete '/api/v1/logout', headers: {"ACCEPT" => "application/json", 'Token' => logintoken}
        expect(response).to have_http_status(201)

        # this test makes sure that the token has been destory
        delete '/api/v1/logout', headers: {"ACCEPT" => "application/json", 'Token' =>   token}
>>>>>>> master
        expect(response).to have_http_status(401)
    end
end





