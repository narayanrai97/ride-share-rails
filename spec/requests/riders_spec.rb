require 'rails_helper'

RSpec.describe "Api::V1::Riders", type: :request do
# This Return all riders
    let!(:organization) { FactoryBot.create(:organization) }
    let!(:rider) {FactoryBot.create(:rider, organization_id: organization.id) }
    let!(:rider1) {FactoryBot.create(:rider, organization_id: organization.id, email: "a1@.com") }
    let!(:rider2) {FactoryBot.create(:rider, organization_id: organization.id, email: "stuff@mail.com") }
    it "returns all riders" do
   get '/api/v1/riders', headers: {"ACCEPT" => "application/json" }
   expect(response).to have_http_status(200)
   puts response.body
    end
# This test Return a rider with a given ID
  it "returns rider ID" do
  get '/api/v1/rider', headers: {"ACCEPT" => "application/json" }, params: {id: rider.id }
  expect(response).to have_http_status(200)
  puts response.body
  end
end

 