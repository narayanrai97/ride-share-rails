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
      post "login", root: :driver do
        create_token(params[:email], params[:password])
      end

      desc "Destroys token"
      params do
      end
      post "logout", root: :driver do
        destroy_token
      end


    end
  end
end