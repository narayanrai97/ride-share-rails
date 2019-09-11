require 'rails_helper'

RSpec.describe "Api::V1::Riders", type: :request do
# This Return all riders
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:rider) {FactoryBot.create(:rider, organization_id: organization.id) }
    let!(:rider1) {FactoryBot.create(:rider, organization_id: organization.id, email: "a1@.com") }
    let!(:rider2) {FactoryBot.create(:rider, organization_id: organization.id, email: "stuff@mail.com") }
    
   it "returns all riders" do
    get '/api/v1/riders', headers: {"ACCEPT" => "application/json" }
    expect(response).to have_http_status(201)
   end
   
   it "returns a 404 error when there nothing to retrive" do
    Rider.destroy_all
    get '/api/v1/riders', headers: {"ACCEPT" => "application/json" }
    expect(response).to have_http_status(404)
   end
    
# This test Return a rider with a given ID
  it "returns rider ID" do
    get "/api/v1/riders/#{rider.id}", headers: {"ACCEPT" => "application/json" }
    expect(response).to have_http_status(201)
  end
  
  it "returns a 404 error when id can not be found" do
    get "/api/v1/riders/#{102319}", headers: {"ACCEPT" => "application/json" }
    expect(response).to have_http_status(404)
  end
end

 