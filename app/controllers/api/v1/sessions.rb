module Api
  module V1
    class Sessions < Grape::API

      include Api::V1::Defaults
      helpers SessionHelpers


      desc "Login and return a token on successful login"
      params do
        requires :email, type: String, desc: "Email of account"
        requires :password, type: String, desc: "Password of account"
      end

      # Initial login endpoint
      post "login", root: :driver do
        create_token(params[:email], params[:password])
      end

      # Login endpoint with drivers active and approval
      post "login1", root: :driver do
        token = create_token(params[:email], params[:password])
        approved = current_driver.background_check && current_driver.application_state == 'accepted'
        if current_driver.is_active
          active = true
        else
          active = false
        end

        {token: token, approved: approved, active: active}
      end

      desc "Destroys token"
      params do
      end
      delete "logout", root: :driver do
        destroy_token
      end
    end
  end
end
