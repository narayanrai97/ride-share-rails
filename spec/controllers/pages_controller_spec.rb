require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #privacy_policy" do
    it "returns http success" do
      get :privacy_policy
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #terms_and_conditions" do
    it "returns http success" do
      get :terms_and_conditions
      expect(response).to have_http_status(:success)
    end
  end

end
