module Api
  module V1
    class Sessions < Grape::API

      include Api::V1::Defaults
      helpers SessionHelpers


      # desc "Login and return a `token` on successful login"
      # params do
      #   requires :email, type: String, desc: "Email of account"
      #   requires :password, type: String, desc: "Password of account"
      # end
      # post "login", root: :driver do
      #   create_token(params[:email], params[:password])
      # end

      desc "Return a `token` along with `active` and `approval` flags on successful login"
      params do
        requires :email, type: String, desc: "Email of account"
        requires :password, type: String, desc: "Password of account"
      end
      post "login", root: :driver do
        token = create_token(params[:email], params[:password])
        return token if !token[:json][:errors].nil?
        driver = Driver.find_by_email(params[:email])
        token[:json][:approved] = driver.background_check && driver.application_state == 'accepted'
        if driver.is_active
          active = true
        else
          active = false
        end
        token[:json][:active] = active
        token
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
