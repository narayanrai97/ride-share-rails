require 'rails_helper'

RSpec.feature "Drivers", type: :feature, js: true do
  include Features::SessionHelpers

  let!(:organization) { create :organization}
  let!(:organization_2) {create :organization, name: 'NC State' }
  let!(:admin) { create :user }
  let!(:driver) { create :driver, organization_id: admin.organization.id }
  let!(:driver_outside_organization) { create :driver, email: 'adriver@gmail.com' }

    scenario "log in as admin" do
      visit root_path
      click_link 'Login as Admin'
      expect(page).to have_text "Log in"
      signin('user@example.com', 'password')
      expect(page).to have_text "Welcome Admins!"
    end

    # Test for github config
    
    # Example:
    # scenario 'user can sign in with valid credentials' do
    #   user = create(:user)
    #   signin(user.email, user.password)
    #   expect(page).to have_content I18n.t 'devise.sessions.signed_in'
    # end

    # Example:
    # scenario 'user cannot sign in if not registered' do
    #   signin('test@example.com', 'please123')
    #   expect(page).to have_content I18n.t 'devise.failure.invalid', authentication_keys: 'email'
    # end

    # scenario "fail if given invalid name or password for admin" do
    #   # visit http://localhost:3000/welcome/index
    #
    # end

    # scenario "show and validate the Drivers page" do

    # end
end

# EXAMPLE:
# require 'rails_helper'
#
# RSpec.feature "Messages", type: :feature, js: true do
#   let!(:message) { create :message, title: "Alert!" }
#   let!(:admin) { create :user, :admin, email: "admin@example.com", password: "foobar"}
#   let!(:user_message) { create :message, posted: false, posted_at: Time.now }
#
#   scenario "user sees message" do
#     visit root_path(locale: 'en')
#     expect(page).to have_text "Alert!"
#     click_button 'my_x_button'
#     expect(page).to_not have_text "Alert!"
#   end
#
#   scenario "displays user messages when visitor clicks `bell` icon" do
#     visit root_path(locale: 'en')
#     click_button 'my_x_button' #hides message
#     click_link 'my_icon_link'   #displays user_messages
#     expect(page).to have_text "Alert History"
#   end
#
#   scenario "displays list of messages" do
#     signin('admin@example.com', 'foobar')
#     visit root_path(locale: 'en')
#     expect(page).to have_text('Messages') #actually wanted to test as a link (`have_link`)
#     click_link 'my_messages_link' #redirects to message index page
#     expect(page).to have_text "Message Center"
#   end
#
# end
