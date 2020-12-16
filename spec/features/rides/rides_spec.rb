# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Rides', type: :feature, js: true do
  include Features::SessionHelpers

  let!(:organization) { create :organization }
  let!(:organization_2) { create :organization, name: 'NC State' }
  let!(:admin) { create :user }
  let!(:location1) { create :location, street: "100 Main St", city: 'Durham', state: "NC", zip: "27713" }
  let!(:rider) { create :rider, organization_id: admin.organization.id }
  let!(:ride_category) { create :ride_category, organization_id: organization.id}
  let!(:ride){create(:ride, organization_id: admin.organization.id, rider_id: rider.id,
    start_location_id: location1.id, end_location_id: location1.id, reasons_attributes: [ride_category_id: ride_category.id])}

  scenario 'log in as admin' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'Pa$$word20')
    expect(page).to have_link 'Rides'
  end

  scenario 'attempt to login as admin with incorrect password' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'wrongpw')
    expect(page).to have_text 'Invalid Email or password.'
  end

  scenario 'when admin selects list of rides, check that all rides are in org' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: 'Pa$$word20'
    click_on 'Log in'
    expect(page).to have_link 'Rides'
    click_link 'Rides'
    expect(Ride.last.reason).to have_text ride.reason
    expect(Ride.last.status).to have_text ride.status
  end
end
