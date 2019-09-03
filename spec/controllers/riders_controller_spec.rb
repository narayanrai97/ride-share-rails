# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RidersController, type: :controller do
  let!(:user) { create :user }
  let!(:rider) { create :rider, organization_id: user.organization.id }
  let!(:rider_outside_organization) { create :rider, email: 'whatever@gmail.com' }

  before do
    sign_in user
  end

  it 'creates a rider' do
    expect do
      test_response = post :create, params: {
        rider: {
          first_name: 'John',
          last_name: 'Doe',
          phone: '12345',
          email: 'wasemail@this.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }

      expect(test_response.response_code).to eq(302)
      expect(test_response).to redirect_to(Rider.last)
    end.to change(Rider, :count)
  end

  it 'updates a rider' do
    test_response = put :update, params: {
      id: rider.id,
      rider: {
        first_name: 'Jane'
      }
    }

    rider.reload
    expect(rider.first_name).to eq('Jane')
    expect(test_response.response_code).to eq(302)
    expect(test_response).to redirect_to(rider)
  end

  it 'fails to update a rider in a different organization than active user' do
    test_response = put :update, params: {
      id: rider_outside_organization.id,
      rider: {
        first_name: 'Jane'
      }
    }

    expect(rider_outside_organization.first_name).to_not eq('Jane')
    expect(test_response.response_code).to eq(302)
    expect(test_response).to redirect_to(riders_path)
    expect(flash[:notice]).to match(/not authorized/)
  end

  # It statements to be created below:

  # it 'bulk updates tokens for a rider'
  # it 'fails to update tokens for a rider in a different organization than the active user'
  # it 'deactivates a rider'
  # it 'fails to deactivate a rider in a different organization than the active user'
end
