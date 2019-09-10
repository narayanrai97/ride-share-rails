require 'rails_helper'

RSpec.describe Api::V1::Rides, type: :request do
  #Drivers require a organization to assosiate with
  let!(:organization) {create(:organization) }
  #Created a token to by pass login but had to include
  #token_created_at in the last day so it would function
  let!(:driver) {create(:driver, organization_id: organization.id,
     auth_token: "1234",token_created_at: Time.zone.now) }
  let!(:driver2) {create(:driver, organization_id: organization.id,
     auth_token: "4567",token_created_at: Time.zone.now) }
  let!(:rider){create(:rider)}
  let!(:location) {create(:location)}
  let!(:location1) {create(:location,  street:"10 Front Street")}
  let!(:ride){create(:ride,rider_id: rider.id,organization_id: organization.id,
    start_location_id: location.id, end_location_id: location1.id)}
  let!(:ride1){create(:ride,rider_id: rider.id,organization_id: organization.id,
     driver_id: driver.id,status: "scheduled",
     start_location_id: location.id, end_location_id: location1.id)}
  let!(:ride2){create(:ride,rider_id: rider.id,organization_id: organization.id,
    driver_id: driver.id,status: "pending",
    start_location_id: location.id, end_location_id: location1.id)}
  let!(:ride3){create(:ride,rider_id: rider.id,organization_id: organization.id,
     driver_id: driver.id,status: "scheduled",
     start_location_id: location.id, end_location_id: location1.id)}



  #Accepts a ride for the current logged in user.
  #This added the driver id to the ride and changes the status to scheduled
  it 'will accept a ride for the driver' do
    post "/api/v1/rides/#{ride.id}/accept",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}
    parsed_json = JSON.parse(response.body)
    puts parsed_json
    expect(response).to have_http_status(201)
    expect(parsed_json['ride']['driver_id']).to eq(driver.id)
    expect(parsed_json['ride']['status']).to eq("scheduled")
  end
  #Accepts a ride for the current logged user
  it 'will return a 404 error when ride does not belong to driver ' do
    post "/api/v1/rides/#{6565}/accept",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}
    parsed_json = JSON.parse(response.body)
    puts parsed_json
    expect(response).to have_http_status(404)
    
  end
  
  #Accepts a ride for the current logged user
  it 'will return a 401 error when ride does not belong to driver ' do
    post "/api/v1/rides/#{6565}/accept",  headers: {"ACCEPT" => "application/json",  "Token" => "4567"}
    parsed_json = JSON.parse(response.body)
    puts parsed_json
    expect(response).to have_http_status(404)
    
  end

  #Changes status of ride to completed
  it 'will complete a ride for a driver' do
    post "/api/v1/rides/#{ride1.id}/complete",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}
    parsed_json = JSON.parse(response.body)
    puts parsed_json
    expect(response).to have_http_status(201)
    expect(parsed_json['ride']['status']).to eq("completed")
  end

  it 'will cancel a ride for a driver' do
    post "/api/v1/rides/#{ride1.id}/cancel",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}
    parsed_json = JSON.parse(response.body)
    expect(parsed_json['ride']['status']).to eq("canceled")
  end

  it 'will change status to picking up on a ride for a driver' do
    post "/api/v1/rides/#{ride1.id}/picking-up",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}
    parsed_json = JSON.parse(response.body)
    expect(parsed_json['ride']['status']).to eq("picking-up")
  end

  it 'will change status to dropping off for a ride for a driver' do
    post "/api/v1/rides/#{ride1.id}/dropping-off",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}
    parsed_json = JSON.parse(response.body)
    expect(parsed_json['ride']['status']).to eq("dropping-off")
  end

  it 'will return a ride based off id ' do
    get "/api/v1/rides/#{ride1.id}",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}
    parsed_json = JSON.parse(response.body)
    #Checks to see if it equals what i set it to.
    expect(parsed_json['ride']['driver_id']).to eq(driver.id)
    expect(parsed_json['ride']['organization_id']).to eq(organization.id)
    expect(parsed_json['ride']['start_location']['id']).to eq(location.id)
    expect(parsed_json['ride']['end_location']['id']).to eq(location1.id)
  end
  context "rides list return different params " do
    #Returns all rides that have not been filled with a driver
    it 'will return all rides without drivers ' do
      get "/api/v1/rides",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}
      parsed_json = JSON.parse(response.body)
      #nil because no driver has accepted it yet
      expect(parsed_json['rides'][0]['driver_id']).to eq(nil)
    end

    # returns rides that only the driver has accepted
    it 'will return all rides that the  driver has accepted ' do
      get "/api/v1/rides",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}, params:{driver_specific: true}
      parsed_json = JSON.parse(response.body)
      #Driver should own all of these rides
      expect(parsed_json['rides'][0]['driver_id']).to eq(driver.id)
      expect(parsed_json['rides'][1]['driver_id']).to eq(driver.id)
      expect(parsed_json['rides'][2]['driver_id']).to eq(driver.id)
    end

    #Returns rides based on status matching scheduled and driver accepted
    it 'will return all rides with status scheduled' do
      get "/api/v1/rides",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}, params:{driver_specific: true, status: "scheduled"}
      parsed_json = JSON.parse(response.body)
      puts parsed_json
      #should only have scheduled result, only should return one object
      expect(parsed_json['rides'][0]['status']).to eq("scheduled")
    end
  #Returns rides of driver with a start and end time and drivewr accepted, May want to loop through results
    it 'will return all rides start date' do
      get "/api/v1/rides",  headers: {"ACCEPT" => "application/json",  "Token" => "1234"}, params:{driver_specific: true, start: Date.today, end: Date.today + 15}
      parsed_json = JSON.parse(response.body)
      puts parsed_json
      #Time formatting includes timezone information z and miliseconds
      expect(parsed_json['rides'][0]['pick_up_time'].to_date).to eq(((Time.now.utc + 5.days).round(10).iso8601(3).to_date))
    end
  end
end
