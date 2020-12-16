# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Riders', type: :feature, js: true do
  include Features::SessionHelpers

  let!(:organization) { create :organization }
  let!(:admin) { create :user }
  let!(:rider) { create :rider, organization_id: admin.organization.id }
  let!(:rider_outside_organization) { create :rider, email: 'arider@gmail.com', first_name: 'Joey' }
  let!(:location) { create :location }
  let!(:location1) { create :location, street: '100 Main St', city: 'Durham', state: 'NC', zip: '27713' }
  let!(:ride_category) { create :ride_category, organization_id: organization.id}
  let!(:ride){create(:ride, rider_id: rider.id, organization_id: admin.organization.id,
    start_location_id: location1.id, end_location_id: location1.id, reasons_attributes: [details: "buy foods", ride_category_id: ride_category.id])}
  let!(:location_relationship) { create :location_relationship, rider_id: rider.id, location_id: location.id }

  scenario 'when admin selects list of riders, check that all riders are in org' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: 'Pa$$word20'
    click_on 'Log in'
    expect(page).to have_link 'Riders'
    click_link 'Riders'
    expect(page).to have_text rider.first_name
    expect(page).not_to have_text rider_outside_organization.first_name
  end

  scenario 'when admin clicks show, fields should be populated' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'Pa$$word20')
    expect(page).to have_link 'Riders'
    click_link 'Riders'
    page.find(:css, ".clickable-row").click()
    expect(page).to have_text 'Rider Information'
    expect(page).to have_text rider.first_name
    display_phone = rider.phone[0..2] + '-' + rider.phone[3..5] + '-' + rider.phone[6..9]
    expect(page).to have_text display_phone
    expect(page).to have_text location.street
    expect(page).to have_text ride.reason
  end
end
