require 'rails_helper'

RSpec.feature "Riders::RiderPasswordResets", type: :feature do
  let!(:rider) { create :rider }

  xit "sends a password reset link if a valid email is provided" do
    visit new_rider_session_path
    click_link "Forgot your password?"
    expect(page).to have_selector('h2', text: 'Forgot your password?')
    fill_in "Email", :with => rider.email
    click_button "Send me reset password instructions"
    expect(current_path).to eql(new_rider_session_path)
    expect(page).to have_text "Log in"
  end

  xit "error occurs if an invalid email is provided" do
    visit new_rider_session_path
    click_link "Forgot your password?"
    expect(page).to have_selector('h2', text: 'Forgot your password?')
    fill_in "Email", :with => 'invalid_rider@example.com'
    click_button "Send me reset password instructions"
    expect(current_path).to eql(rider_password_path)
    expect(page).to have_text "Email not found"
  end
end
