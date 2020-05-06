# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Drivers', type: :feature, js: true do
  include Features::SessionHelpers

  let!(:organization) { create :organization }
  let!(:organization_2) { create :organization, name: 'NC State' }
  let!(:admin) { create :user }
  let!(:driver) { create :driver, organization_id: admin.organization.id }
  let!(:driver_outside_organization) { create :driver, email: 'adriver@gmail.com', first_name: 'Jerry' }
  let!(:location) { create :location, street: '201 W Main st', city: 'Durham', state: 'NC', zip: '27701' }
  let!(:location1) { create :location, street: "400 Main St", city: 'Durham', state: "NC", zip: "27713" }
  let!(:location_relationship) { create :location_relationship, driver_id: driver.id, location_id: location.id, default: true }
  let!(:vehicle1) { create :vehicle, driver_id: driver.id }
  let!(:schedule_window) { create :schedule_window, driver_id: driver.id, location_id: location.id }
  let!(:schedule_window1) { create :schedule_window, driver_id: driver.id, location_id: location1.id }

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

  scenario 'when admin selects list of drivers, check that all drivers are in org 'do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: 'Pa$$word20'
    click_on 'Log in'
    expect(page).to have_link "Drivers"
    click_link 'Drivers'
    expect(page).to have_text driver.first_name
    expect(page).not_to have_text driver_outside_organization.first_name
  end

  scenario 'when admin clicks review, fields should be populated' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'Pa$$word20')
    expect(page).to have_link 'Drivers'
    click_link 'Drivers'
    page.find(:css, ".clickable-row").click()
    expect(page).to have_text 'Driver Information'
    expect(page).to have_text driver.first_name
    expect(page).to have_text driver.vehicles[0].car_make
    expect(page).to have_text location.street
  end

  scenario 'when admin clicks review, should be able to add car' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'Pa$$word20')
    expect(page).to have_link 'Drivers'
    click_link 'Drivers'
    page.find(:css, ".clickable-row").click()
    expect(page).to have_text 'Cars'
    click_link 'Add Car'
    expect(page).to have_text 'New Vehicle of'
    expect(page).to have_text driver.first_name
  end

  # Following scenario still in process. Need to do an xpath find by href.

  # scenario 'when admin clicks review, should be able to edit car' do
  #   visit root_path
  #   click_link 'Login as Admin'
  #   expect(page).to have_text 'Log in'
  #   signin('user@example.com', 'password')
  #   expect(page).to have_text 'Welcome user@example.com!'
  #   click_link 'Drivers'
  #   click_link 'Review'
  #   expect(page).to have_text 'Cars'
  #   click_link 'Edit'
  #   expect(page).to have_text 'Edit Vehicle of'
  #   expect(page).to have_text driver.first_name
  # end

  scenario 'when admin clicks review, should be able edit driver' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'Pa$$word20')
    expect(page).to have_link 'Drivers'
    click_link 'Drivers'
    page.find(:css, ".clickable-row").click()
    click_link 'Edit'
    expect(page).to have_text 'Update Driver'
  end

  scenario 'when admin clicks edit, Update Driver fields should appear' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'Pa$$word20')
    expect(page).to have_link 'Drivers'
    click_link 'Drivers'
    page.find(:css, ".clickable-row").click()
    click_link 'Edit'
    expect(page).to have_text 'Update Driver'
  end
end
