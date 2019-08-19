require 'rails_helper'

RSpec.describe Api::V1::Locations, type: :request do
  #Drivers require a organization to assosiate with
  let!(:organization) { FactoryBot.create(:organization) }
  #Created a token to by pass login but had to include
  #token_created_at in the last day so it would function
  let!(:driver) { FactoryBot.create(:driver, organization_id: organization.id,
     auth_token: "1234",token_created_at: Time.zone.now) }
     #To test locations I needed to create some locations and also some relationships
  let!(:location){FactoryBot.create(:location)}
  let!(:locationrelationship){LocationRelationship.create(driver_id: driver.id, location_id: location.id)}


    #Created a Location based on the logged in user. Uses token previously created
  it 'will create a location related to logged in user' do

    post '/api/v1/locations', headers: {"ACCEPT" => "application/json",  "Token" => "1234"},
      params: {location:{street:"200 Front Street",
      city:"Burlington",
      state:"NC",
      zip: "27215"}}

      expect(response).to have_http_status(201)
      parsed_json = JSON.parse(response.body)
      puts parsed_json

      expect(parsed_json['location']['street']).to eq('200 Front Street')
      expect(parsed_json['location']['city']).to eq("Burlington")
      expect(parsed_json['location']['state']).to eq('NC')
      expect(parsed_json['location']['zip']).to eq( "27215")
      expect(parsed_json['location']['location_relationships'][0]['driver_id']).to eq( driver.id)


  end




  it 'will return locations of driver ' do

    get '/api/v1/locations', headers: {"ACCEPT" => "application/json",  "Token" => "1234"}

      expect(response).to have_http_status(200)
      parsed_json = JSON.parse(response.body)
    
      locations = parsed_json['locations']
      location = locations.first
      expect(location['street']).to eq('1200 front st.')
      expect(parsed_json['locations'][0]['city']).to eq('Durham')
      expect(parsed_json['locations'][0]['state']).to eq('NC')
      expect(parsed_json['locations'][0]['zip']).to eq( "27705")
  end

  #Give the api a location id and get back information for it
  #Needs to verify user owns location
  it 'will return a location based on id passed ' do

    get "/api/v1/locations/#{location.id}", headers: {"ACCEPT" => "application/json",  "Token" => "1234"}

      expect(response).to have_http_status(200)
      parsed_json = JSON.parse(response.body)
      # puts parsed_json
      expect(parsed_json['location']['street']).to eq('1200 front st.')
      expect(parsed_json['location']['city']).to eq('Durham')
      expect(parsed_json['location']['state']).to eq('NC')
      expect(parsed_json['location']['zip']).to eq( "27705")


  end
  #Delete Record based on id
  it 'will delete a location based on id passed ' do

    delete "/api/v1/locations/#{location.id}", headers: {"ACCEPT" => "application/json",  "Token" => "1234"}

      expect(response).to have_http_status(200)
      parsed_json = JSON.parse(response.body)
      #puts parsed_json
      expect(parsed_json['success']).to eq(true)



  end

  it 'will update a location related to logged in user' do

    put "/api/v1/locations/#{location.id}", headers: {"ACCEPT" => "application/json",  "Token" => "1234"},
      params: {location:{street:"210 Front Street",
      city:"Burlington",
      state:"NC",
      zip: "27217"}}

      expect(response).to have_http_status(200)
      parsed_json = JSON.parse(response.body)
      #puts parsed_json
      expect(parsed_json['location']['street']).to eq('210 Front Street')
      expect(parsed_json['location']['city']).to eq("Burlington")
      expect(parsed_json['location']['state']).to eq('NC')
      expect(parsed_json['location']['zip']).to eq( "27217")
      expect(parsed_json['location']['location_relationships'][0]['driver_id']).to eq( driver.id)


  end



end
