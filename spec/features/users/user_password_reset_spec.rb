require 'rails_helper'

RSpec.feature "Users password reset", type: :feature do
  let!(:user) { create :user, email: "user@example.com"}

  scenario "user receives a password reset link in his/her email" do
    visit root_path
    expect(page).to have_text "FRUBER"

    click_link 'admin-login'
    expect(page).to have_text "Log in"

    click_link "Forgot your password?"
    expect(page).to have_selector('h2', text: 'Forgot your password?')

    fill_in "Email", :with => user.email
    click_button "Send me reset password instructions"

    expect(current_path).to eql(new_user_session_path)
    expect(page).to have_text "Log in"
  end
end
