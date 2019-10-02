# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Drivers', type: :feature, js: true do
  include Features::SessionHelpers

  let!(:organization) { create :organization }
  let!(:organization_2) { create :organization, name: 'NC State' }
  let!(:admin) { create :user }
  let!(:driver) { create :driver, organization_id: admin.organization.id }
  let!(:driver_outside_organization) { create :driver, email: 'adriver@gmail.com' }
  let!(:location) { create :location, street: '200 Person St', city: 'Raleigh', state: 'NC', zip: 23459 }
  let!(:vehicle1) { create :vehicle, driver_id: driver.id }
  let!(:schedule1) { create :schedule_window, driver_id: driver.id, location_id: location.id }

  scenario 'log in as admin' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'password')
    expect(page).to have_text 'Welcome Admins!'
  end

  scenario 'attempt to login as admin with incorrect password' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'wrongpw')
    expect(page).to have_text 'Invalid Email or password.'
  end

  scenario 'when admin selects list of drivers, check that all drivers are in org 'do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'password')
    expect(page).to have_text 'Welcome Admins!'
    visit drivers_path
    expect(page).to have_text 'Ben'
    expect(page).not_to have_text 'adriver@gmail.com'
  end

  scenario 'when admin clicks review, fields should be populated' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'password')
    expect(page).to have_text 'Welcome Admins!'
    visit drivers_path
    click_link 'Review'
    expect(page).to have_text 'Driver Information'
    expect(page).to have_text 'Ben'
    expect(page).to have_text 'Nissan'
    # expect... schedule
    # expect... location
  end
end
