# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Rides', type: :feature, js: true do
  include Features::SessionHelpers

  let!(:organization) { create :organization }
  let!(:location1) { create :location, street: "100 Main St", city: 'Durham', state: "NC", zip: "27713" }
  let!(:rider) { create :rider }
  let!(:ride){create(:ride, organization_id: rider.organization.id, rider_id: rider.id,
    start_location_id: location1.id, end_location_id: location1.id)}

  xit 'log in as rider' do
    visit root_path
    click_link 'Login as Rider'
    expect(page).to have_text 'Log in'
    fill_in 'Email', with: rider.email
    fill_in 'Password', with: 'Pa$$word20'
    click_on 'Log in'
    expect(page).to have_text rider.first_name
  end

  xit 'attempt to login as rider with incorrect password' do
    visit root_path
    click_link 'Login as Rider'
    expect(page).to have_text 'Log in'
    fill_in 'Email', with: rider.email
    fill_in 'Password', with: 'wrongpw'
    click_on 'Log in'
    expect(page).to have_text 'Invalid Email or password.'
  end

  xit 'when rider selects list of rides, check that all rides are in org' do
    visit root_path
    click_link 'Login as Rider'
    expect(page).to have_text 'Log in'
    fill_in 'Email', with: rider.email
    fill_in 'Password', with: 'Pa$$word20'
    click_on 'Log in'
    expect(page).to have_text rider.first_name
    click_link 'Rides'
    expect(page).to have_text ride.reason
    expect(page).to have_text ride.status
  end
end
