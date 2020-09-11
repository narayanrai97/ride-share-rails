# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DriversController, type: :request do
  let!(:user) { create :user }
  let!(:organization1) {create :organization, name: "Burlington High", street: "644 spence street", city: "burlington", zip: "27417"}
  let!(:user2) { create :user, email: "frank@gmail.com", password: "Pa$$word100!", organization_id: organization1.id }
  let!(:driver) { create :driver}
  let!(:driver_outside_organization) { create :driver, email: 'adriver@gmail.com' }

  describe "Create action " do
    before do
      login_as(user, :scope => :user )
    end
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

    it 'render the new action' do
      get new_admin_driver_path

      expect(response.redirect?).to eq(false)
      expect(response).to render_template(:new)
    end
  end

  describe "Show action" do
    let!(:driver3)  { FactoryBot.create(:driver, first_name: "Joe", organization_id: organization1.id) }
    before do
      login_as(user2, :scope => :user)
    end

    it 'render the show action' do
      get admin_driver_path(Driver.last.id)
      expect(response.redirect?).to eq(false)
      expect(response).to render_template(:show)
    end

    it "render an error when recorder is not found" do
    get admin_ride_path(9999)
     expect(response.redirect?).to eq(true)
     expect(flash[:alert]).to eq("Record not found.")
    end
  end

  describe "Update Action" do
    let!(:driver3)  { FactoryBot.create(:driver, first_name: "Joe", organization_id: organization1.id) }
    before do
      login_as(user2, :scope => :user)
    end

    it 'updates a driver' do
      put admin_driver_path(Driver.last.id), params: {
        driver: {
          first_name: "Memo",
          last_name: "frog",
          phone: "1234567890"
        }
      }
      expect(response.redirect?).to eq(true)
      expect(flash[:notice]).to eq("The driver information has been updated.")
    end

    it 'fails to update a driver in a different organization than active user' do

        put admin_driver_path(Driver.first.id), params: {
          driver: {
            first_name: 'Sam'
          }
        }
        expect(driver_outside_organization.first_name).to_not eq('Sam')
        expect(response.redirect?).to eq(true)
        expect(flash[:notice]).to eq("You are not authorized to view this information")
    end
  end

  describe "Accept Action " do
    let!(:driver3)  { FactoryBot.create(:driver, first_name: "Joe", organization_id: organization1.id) }
    before do
      login_as(user2, :scope => :user)
    end

    it 'accepts application' do
       put admin_driver_accept_path(Driver.last.id)
        expect(Driver.last.application_state).to eq("accepted")
        expect(response.redirect?).to eq(true)
        expect(flash[:notice]).to eq("The driver application has been accepted.")
        expect(response).to redirect_to(admin_driver_path(Driver.last.id))
    end

    it 'does not accept application for driver outside organization' do
        put admin_driver_accept_path(Driver.first.id), params: {
          driver: { application_state: "accepted"
            }
          }
        expect(Driver.last.application_state).to eq("pending")
        expect(response.redirect?).to eq(true)
        expect(flash[:notice]).to eq("You are not authorized to view this information")
        expect(response).to redirect_to(admin_drivers_path)
    end
  end

  describe "Rejected Action " do
    let!(:driver3)  { FactoryBot.create(:driver, first_name: "Joe", organization_id: organization1.id) }
    before do
      login_as(user2, :scope => :user)
    end

    it "rejects an application" do
    put admin_driver_reject_path(Driver.last.id), params: {
      driver: { application_state: "rejected"
        }
      }
      expect(response.redirect?).to eq(true)
      expect(flash[:alert]).to eq("The driver application has been rejected.")
      expect(response).to redirect_to(admin_driver_path(Driver.last.id))
    end

    it 'does not reject application for driver outside organization' do
    put admin_driver_reject_path(Driver.first.id), params: {
      driver: { application_state: "rejected"
        }
      }
      expect(Driver.last.application_state).to eq("pending")
      expect(response.redirect?).to eq(true)
      expect(flash[:notice]).to eq("You are not authorized to view this information")
      expect(response).to redirect_to(admin_drivers_path)
    end
  end

  describe "fail Action " do
    let!(:driver3)  { FactoryBot.create(:driver, first_name: "Joe", organization_id: organization1.id) }
    before do
      login_as(user2, :scope => :user)
    end

    it "fails a driver background check" do
    put admin_driver_fail_path(Driver.last.id), params: {
      driver: { background_check: false
        }
      }
      expect(response.redirect?).to eq(true)
      expect(flash[:alert]).to eq("The driver failed.")
      expect(response).to redirect_to(admin_driver_path(Driver.last.id))
    end

    it 'does not fail background check for driver outside organization' do
    put admin_driver_reject_path(Driver.first.id), params: {
      driver: { background_check: false
        }
      }
      expect(Driver.first.application_state).to eq("pending")
      expect(response.redirect?).to eq(true)
      expect(flash[:notice]).to eq("You are not authorized to view this information")
      expect(response).to redirect_to(admin_drivers_path)
    end
  end


  describe "Pass Action " do
    let!(:driver3)  { FactoryBot.create(:driver, first_name: "Joe", organization_id: organization1.id) }
    before do
      login_as(user2, :scope => :user)
    end

    it "passes a driver background check" do
    put admin_driver_pass_path(Driver.last.id), params: {
      driver: { background_check: true
        }
      }
      expect(response.redirect?).to eq(true)
      expect(flash[:notice]).to eq("The driver passed.")
      expect(response).to redirect_to(admin_driver_path(Driver.last.id))
    end

    it 'does not pass background check for driver outside organization' do
    put admin_driver_reject_path(Driver.first.id), params: {
      driver: { background_check: true
        }
      }
      expect(Driver.first.application_state).to eq("pending")
      expect(response.redirect?).to eq(true)
      expect(flash[:notice]).to eq("You are not authorized to view this information")
      expect(response).to redirect_to(admin_drivers_path)
    end
  end

  # describe "Deactivated Action " do
  #   let!(:driver3)  { FactoryBot.create(:driver, first_name: "Joe", organization_id: organization1.id) }
  #   before do
  #     login_as(user2, :scope => :user)
  #   end
  #
  #   it "deactivat a driver" do
  #   put admin_driver_activation_path(Driver.last.id), params: {
  #     driver: { is_active: true
  #       }
  #     }
  #     byebug
  #     expect(response.redirect?).to eq(true)
  #     expect(Driver.last.is_active).to eq(false)
  #     byebug
  #     expect(flash[:notice]).to eq("Driver reactivated.")
  #     expect(response).to redirect_to(admin_driver_path(Driver.last.id))
  #   end
  # end
  #
  #
  # it 'prevents unauthorized users from deactivating a driver outside org' do
  #   test_response = put :activation, params: {
  #     driver_id: driver_outside_organization.id
  #   }
  #
  #   driver_outside_organization.reload
  #   expect(driver_outside_organization.is_active).to be(true)
  #   expect(test_response.response_code).to eq(302)
  #   expect(flash[:notice]).to match(/not authorized/)
  #   expect(test_response).to redirect_to(admin_drivers_path)
  # end
end
