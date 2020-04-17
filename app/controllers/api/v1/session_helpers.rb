module Api
  module V1
    module SessionHelpers

      def driver_signed_in?
        current_driver.present?
      end

      def require_login!
        if authenticate_token != nil
          return true
        else
          return false
        end
      end


      def current_driver
        @_current_driver ||= authenticate_token
      end

      def validate_current_driver!
        if current_driver && current_driver.is_active == true && current_driver.background_check == true && current_driver.application_state == "accepted"
          return true
        else
          return false
        end
      end


      def create_token(email, password)
        resource = Driver.find_for_database_authentication(:email => email)
        resource ||= Driver.new
        if resource.valid_password?(password)
          auth_token = resource.generate_auth_token
          status 201
          render json: { auth_token: auth_token }
        else
          invalid_login_attempt
        end

      end

      def destroy_token
        resource = current_driver
        if (resource != nil)
          resource.invalidate_auth_token
          status 201
          render json: {Success: "Logged Out"}
        else
          status 401
          render json: { errors: [ { detail:"Valid token not provided for logout." }]}
        end
      end


      private
      def invalid_login_attempt
        status 401
        render json: { errors: [ { detail:"Error with your login or password" }]}
      end

      private
      def authenticate_token
        token = headers["Token"]
        if (token != nil)
          if token.start_with?("Token token") #workaround for stupid handling in GrapeSwagger
            token=token.split('"')[1]
          end
        end
        return Driver.where(auth_token: token).where("token_created_at >= ?", 1.day.ago).first
      end
    end
  end
end
