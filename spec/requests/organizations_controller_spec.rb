require 'rails_helper'

RSpec.describe Api::OrganizationsController, type: :request do
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:organization1) { FactoryBot.create(:organization, name: 'Chapel Hill Health') }
    let!(:organization2) { FactoryBot.create(:organization, zip: 27709) }

    it 'driver login in' do
    get '/api/v1/organizations', headers: {"ACCEPT" => "application/json" }


      puts response.body
      parsed_json = JSON.parse(response.body)
      expect(parsed_json['organization'][0]['name']).to eq('Duke')
      expect(parsed_json['organization'][0]['street']).to eq('200 Front Street')
      expect(parsed_json['organization'][0]['city']).to eq('Durham')
      expect(parsed_json['organization'][0]['state']).to eq('NC')
      expect(parsed_json['organization'][0]['zip']).to eq('27708')
      expect(parsed_json['organization'][1]['name']).to eq('Chapel Hill Health')
      expect(parsed_json['organization'][2]['zip']).to eq('27709')

    end

end
