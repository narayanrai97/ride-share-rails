# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DriversController, type: :controller do
  let!(:user) { create :user }
  let!(:driver) { create :driver, organization_id: user.organization.id }
  let!(:driver_outside_organization) { create :driver, email: 'adriver@gmail.com' }

  before do
    sign_in user
  end

  it 'reports an error if the phone number is the wrong length' do
    expect do
      test_response = post :create, params: {
        driver: {
          first_name: 'John',
          last_name: 'Doe',
          phone: '1234567',
          email: 'wasemail@this.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }

      expect(flash[:error][0]).to match(/wrong length/)
      expect(test_response.response_code).to eq(200)
    end.not_to change(Driver, :count)
  end

  it 'creates a driver' do
    expect do
      test_response = post :create, params: {
        driver: {
          first_name: 'John',
          last_name: 'Doe',
          phone: '1234567891',
          email: 'wasemail@this.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }

      expect(flash[:notice]).to match(/has been saved/)
      expect(test_response.response_code).to eq(302)
      expect(test_response).to redirect_to(Driver.last)
    end.to change(Driver, :count)
  end

  it 'updates a driver' do
    test_response = put :update, params: {
      id: driver.id,
      driver: {
        first_name: 'Lucy'
      }
    }

    driver.reload
    expect(driver.first_name).to eq('Lucy')
    expect(test_response.response_code).to eq(302)
    expect(test_response).to redirect_to(driver)
  end

  it 'fails to update a driver in a different organization than active user' do
      test_response = put :update, params: {
        id: driver_outside_organization.id,
        driver: {
          first_name: 'Sam'
        }
      }

      expect(driver_outside_organization.first_name).to_not eq('Sam')
      expect(test_response.response_code).to eq(302)
      expect(test_response).to redirect_to(drivers_path)
      expect(flash[:notice]).to match(/not authorized/)
  end

  it 'accepts application' do
    test_response = put :accept, params: {
      driver_id: driver.id
      }

      driver.reload
      expect(driver.application_state).to eq("accepted")
      expect(test_response.response_code).to eq(302)
      expect(flash[:notice]).to match(/accepted/)
      expect(test_response).to redirect_to(driver)
  end

  it 'does not accept application for driver outside organization' do
      test_response = put :accept, params: {
        driver_id: driver_outside_organization.id,
        driver: { application_state: "accepted"
          }
        }

      driver_outside_organization.reload
      expect(driver_outside_organization.application_state).to eq("pending")
      expect(test_response.response_code).to eq(302)
      expect(test_response.body).to match(/You are being/)
      expect(flash[:notice]).to match(/not authorized/)
      expect(test_response).to redirect_to(drivers_path)
  end

  it 'rejects application' do
    test_response = put :reject, params: {
      driver_id: driver_outside_organization.id
      }

    driver_outside_organization.reload
    expect(driver.application_state).to_not eq("accepted")
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/not authorized/)
    expect(test_response).to redirect_to(drivers_path)
  end

  it 'does not reject application for driver outside organization' do
    test_response = put :accept, params: {
      driver_id: driver_outside_organization.id
      }

    driver_outside_organization.reload
    expect(driver.application_state).to_not eq("rejected")
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/not authorized/)
    expect(test_response).to redirect_to(drivers_path)
  end

  it 'passes driver background check' do
    test_response = put :pass, params: {
      driver_id: driver.id
      }

    driver.reload
    expect(driver.background_check).to eq(true)
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/passed/)
    expect(test_response).to redirect_to(driver)
  end

  it 'fails driver background check' do
    driver.update(background_check: true)
    test_response = put :fail, params: {
      driver_id: driver.id
      }

    driver.reload
    expect(driver.background_check).to eq(false)
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/failed/)
    expect(test_response).to redirect_to(driver)
  end

  it 'prevents unauthorized users from marking a driver background passed' do
    test_response = put :pass, params: {
      driver_id: driver_outside_organization.id
      }

    driver_outside_organization.reload
    expect(driver_outside_organization.background_check).to eq(false)
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/not authorized/)
    expect(test_response).to redirect_to(drivers_path)
  end

  it 'prevents unauthorized users from marking a driver background failed' do
    driver_outside_organization.update(background_check: true)
    test_response = put :fail, params: {
      driver_id: driver_outside_organization
      }

    driver_outside_organization.reload
    expect(driver_outside_organization.background_check).to eq(true)
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/not authorized/)
    expect(test_response).to redirect_to(drivers_path)
  end

  it 'deactivates driver' do
    test_response = put :deactivate, params: {
      driver_id: driver.id
      }

    driver.reload
    expect(driver.is_active).to be(false)
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/deactivated/)
    expect(test_response).to redirect_to(drivers_path)

    test_response_2 = put :deactivate, params: {
      driver_id: driver.id
    }

    driver.reload
    expect(driver.is_active).to be(true)
    expect(test_response_2.response_code).to eq(302)
    expect(flash[:notice]).to match(/set to active/)
    expect(test_response_2).to redirect_to(drivers_path)
  end

  # it 'prevents unauthorized users from deactivating a driver outside org' do
  #
  # end
end
