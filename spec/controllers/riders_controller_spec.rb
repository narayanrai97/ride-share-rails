
require 'rails_helper'

RSpec.describe RidersController, type: :controller do
  let!(:user1){ create :user }

  before do
     sign_in user1
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
   expect(test_response).to redirect_to(Rider.first)
   end.to change(Rider, :count)
 end

  # it 'updates a rider'
  # it 'fails to update a rider in a different organization than the active user'
  # it 'bulk updates tokens for a rider'
  # it 'fails to update tokens for a rider in a different organization than the active user'
  # it 'deactivates a rider'
  # it 'fails to deactivate a rider in a different organization than the active user'

end
