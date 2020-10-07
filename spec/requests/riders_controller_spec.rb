# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RidersController, type: :request do
  let!(:user) { create :user }
  let!(:organization1) {create :organization, name: "Burlington High", street: "644 spence street", city: "burlington", zip: "27417"}
  let!(:rider) { create :rider, organization_id: user.organization.id }
  let!(:token) {create :token, rider_id: rider.id}
  let!(:rider1) { create :rider, first_name: "James", organization_id: organization1.id }
  let!(:rider_outside_organization) { create :rider, email: 'whatever@gmail.com' }

  describe "Create action " do
    before do
      login_as(user, :scope => :user )
    end

    it 'creates a rider' do
      expect do
        post riders_path, params: {
          rider: {
            first_name: 'John',
            last_name: 'Doe',
            phone: '1234567890',
            email: 'wasemail@this.com',
            password: 'Pa$$word20',
            password_confirmation: 'Pa$$word20'
          }
        }
        expect(response.redirect?).to eq(true)
        expect(flash[:notice]).to match("Rider created.")
      end.to change(Rider, :count)
    end

    it 'reports an error if the phone number is the wrong length' do
      expect do
        post riders_path, params: {
          rider: {
            first_name: 'John',
            last_name: 'Doe',
            phone: '1234567',
            email: 'wasemail@this.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        expect(response).to render_template(:new)
      end.not_to change(Rider, :count)
    end
  end

  describe "New action" do
    before do
      login_as(user, :scope => :user )
    end
    it "rider new action" do
      get new_rider_path(rider.id)
      expect(response.redirect?).to eq(false)
      expect(response).to render_template(:new)
    end
  end

  describe "edit action" do
    before do
      login_as(user, :scope => :user )
    end
    it "render edit action" do
      get edit_rider_path(rider.id)
      expect(response.redirect?).to eq(false)
      expect(response).to render_template(:edit)
    end

    it "Error when rider belongs to another organization" do
    get edit_rider_path(rider1.id)
    expect(response.redirect?).to eq(true)
    expect(flash[:notice]).to match("You are not authorized to view this information")
    end
  end

  describe "Show action" do
    before do
      login_as(user, :scope => :user )
    end
    it "rider show action" do
      get rider_path(rider.id)
      expect(response.redirect?).to eq(false)
    end

    it "Error when rider belongs to another organization" do
      get rider_path(rider1.id)
      expect(response.redirect?).to eq(true)
      expect(flash[:notice]).to match("You are not authorized to view this information")
    end
  end

  describe "Update action " do
    before do
      login_as(user, :scope => :user )
    end
    it 'updates a rider' do
      expect do
       put rider_path(rider.id), params: {
        id: rider.id,
        rider: {
          first_name: 'Jane'
        }
      }
      expect(response.redirect?).to eq(true)
      expect(flash[:notice]).to match("The rider information has been updated")
      end.not_to change(Rider, :count)
    end

    it 'fails to update a rider in a different organization' do
      expect do
       put rider_path(rider1.id), params: {
        id: rider.id,
        rider: {
          first_name: 'Jane'
        }
      }
      expect(response.redirect?).to eq(true)
      expect(flash[:notice]).to match("You are not authorized to view this information")
      end.not_to change(Rider, :count)
    end
  end

  describe "Bulk tokens actions " do
    before do
      login_as(user, :scope => :user )
    end

    it 'bulk updates tokens for a rider' do
      post bulk_update_riders_path, params: {
        rider_id: rider.id,
        quantity: 5,
        commit: "Add"
        }
      expect(rider.valid_tokens.count).to eq(6)
      expect(redirect?).to eq(true)
    end

    it 'bulk updates tokens for a rider' do
      post bulk_update_riders_path, params: {
        rider_id: rider.id,
        quantity: 1,
        commit: "Remove"
        }
        expect(rider.valid_tokens.count).to eq(0)
        expect(redirect?).to eq(true)
    end

    it 'fails to update tokens when rider is in a different organization' do
      post bulk_update_riders_path, params: {
        rider_id: rider1.id,
        quantity: 1,
        commit: "Remove"
        }
        expect(rider.valid_tokens.count).to eq(1)
        expect(redirect?).to eq(true)
    end
  end

  describe "Activation action " do
    before do
      login_as(user, :scope => :user )
    end

    it 'deactivates a rider' do
       put rider_activation_path(rider.id), params: {
        is_active: true
      }
      expect(redirect?).to eq(true)
      expect(flash[:alert]).to match("Rider deactivated.")
    end

    it 'fails to deactivate a rider in a different organization' do
       put rider_activation_path(rider1.id), params: {
        is_active: false
      }
      expect(redirect?).to eq(true)
      expect(flash[:notice]).to match("not authorized")
    end
  end
end
