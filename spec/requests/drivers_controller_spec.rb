# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DriversController, type: :request do
  let!(:user) { create :user }
  let!(:driver) { create :driver, organization_id: user.organization.id }
  let!(:organization1) {create :organization, name: "Burlington High", street: "644 spence street", city: "burlington", zip: "27417"}
  let!(:driver_outside_organization) { create :driver, email: 'adriver@gmail.com' }

  describe "Create action " do
    before do
      login_as(user, :scope => :user )
    end
    # byebug
    it 'reports an error if the phone number is the wrong length' do
      expect do
        post admin_drivers_path, params: {
          driver: {
            first_name: 'John',
            last_name: 'Doe',
            phone: '1234567',
            email: 'wasemail@this.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        expect{raise StandardError, "Phone is the wrong length (should be 10 characters)"}.to raise_error(StandardError, "Phone is the wrong length (should be 10 characters)" )
        expect(response).to render_template(:new)
      end.not_to change(Driver, :count)
    end

    it 'creates a driver' do
      expect do
        post admin_drivers_path, params: {
          driver: {
            first_name: 'John',
            last_name: 'Doe',
            phone: '1234567891',
            email: 'wasemail@this.com',
            password: 'Pa$$word20',
            password_confirmation: 'Pa$$word20'
          }
        }
        expect(flash[:notice]).to match("Sign up confirmation email sent to the driver.")
        expect(response.redirect?).to eq(true)
        expect(response.redirect?).to redirect_to(admin_driver_path(Driver.last))
      end.to change(Driver, :count)
    end
  end

  describe "New action" do
    before do
      login_as(user, :scope => :user)
    end

    it 'access the new action' do
      get new_admin_driver_path

      expect(response.redirect?).to eq(false)
      expect(response).to render_template(:new)
    end
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
    expect(test_response).to redirect_to(admin_driver_path)
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
      expect(test_response).to redirect_to(admin_drivers_path)
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
      expect(test_response).to redirect_to(admin_driver_path(driver))
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
      expect(test_response).to redirect_to(admin_drivers_path)
  end

  it 'rejects application' do
    test_response = put :reject, params: {
      driver_id: driver_outside_organization.id
      }

    driver_outside_organization.reload
    expect(driver.application_state).to_not eq("accepted")
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/not authorized/)
    expect(test_response).to redirect_to(admin_drivers_path)
  end

  it 'does not reject application for driver outside organization' do
    test_response = put :accept, params: {
      driver_id: driver_outside_organization.id
      }

    driver_outside_organization.reload
    expect(driver.application_state).to_not eq("rejected")
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/not authorized/)
    expect(test_response).to redirect_to(admin_drivers_path)
  end

  it 'passes driver background check' do
    test_response = put :pass, params: {
      driver_id: driver.id
      }

    driver.reload
    expect(driver.background_check).to eq(true)
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/passed/)
    expect(test_response).to redirect_to(admin_driver_path(driver))
  end

  it 'fails driver background check' do
    driver.update(background_check: true)
    test_response = put :fail, params: {
      driver_id: driver.id
      }

    driver.reload
    expect(driver.background_check).to eq(false)
    expect(test_response.response_code).to eq(302)
    expect(flash[:alert]).to match(/The driver failed./)
    expect(test_response).to redirect_to(admin_driver_path(driver))
  end

  it 'prevents unauthorized users from marking a driver background passed' do
    test_response = put :pass, params: {
      driver_id: driver_outside_organization.id
      }

    driver_outside_organization.reload
    expect(driver_outside_organization.background_check).to eq(false)
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/not authorized/)
    expect(test_response).to redirect_to(admin_drivers_path)
  end

  it 'prevents unauthorized users from marking a driver background failed' do
    driver_outside_organization.update(background_check: true)
    test_response = put :fail, params: {
      driver_id: driver_outside_organization.id
      }

    driver_outside_organization.reload
    expect(driver_outside_organization.background_check).to eq(true)
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/not authorized/)
    expect(test_response).to redirect_to(admin_drivers_path)
  end

  it 'deactivates driver' do
    test_response = put :activation, params: {
      driver_id: driver.id
      }

    driver.reload
    expect(driver.is_active).to be(false)
    expect(test_response.response_code).to eq(302)
    expect(flash[:alert]).to match("Driver deactivated.")
    expect(test_response).to redirect_to(admin_drivers_path)

    test_response_2 = put :activation, params: {
      driver_id: driver.id
    }

    driver.reload
    expect(driver.is_active).to be(true)
    expect(test_response_2.response_code).to eq(302)
    expect(flash[:notice]).to match("Driver reactivated.")
    expect(test_response_2).to redirect_to(admin_drivers_path)
  end

  it 'prevents unauthorized users from deactivating a driver outside org' do
    test_response = put :activation, params: {
      driver_id: driver_outside_organization.id
    }

    driver_outside_organization.reload
    expect(driver_outside_organization.is_active).to be(true)
    expect(test_response.response_code).to eq(302)
    expect(flash[:notice]).to match(/not authorized/)
    expect(test_response).to redirect_to(admin_drivers_path)
  end
end
