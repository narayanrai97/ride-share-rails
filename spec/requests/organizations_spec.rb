require 'rails_helper'

RSpec.describe Api::V1::Organizations, type: :request do
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:organization1) { FactoryBot.create(:organization, name: 'Chapel Hill Health') }
    let!(:organization2) { FactoryBot.create(:organization, zip: 27709) }

    it 'test output of organization endpoint' do
    get '/api/v1/organizations', headers: {"ACCEPT" => "application/json" }
      #puts response.body
      #Checkout out that response is what it should be
      #Only testing parts I changed on the second and third object
      parsed_json = JSON.parse(response.body)
      expect(response).to have_http_status(201)
      expect(parsed_json['organization'][0]['name']).to eq('Duke')
      expect(parsed_json['organization'][0]['street']).to eq('200 Front Street')
      expect(parsed_json['organization'][0]['city']).to eq('Durham')
      expect(parsed_json['organization'][0]['state']).to eq('NC')
      expect(parsed_json['organization'][0]['zip']).to eq('27708')
      expect(parsed_json['organization'][1]['name']).to eq('Chapel Hill Health')
      expect(parsed_json['organization'][2]['zip']).to eq('27709')
    end
    
     it 'should return a 404 error when there nothing to retrieve' do
       Organization.destroy_all
    get '/api/v1/organizations', headers: {"ACCEPT" => "application/json" }
      expect(response).to have_http_status(404)
    end
end
