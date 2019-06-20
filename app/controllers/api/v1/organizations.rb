module Api
  module V1
    class Organizations < Grape::API
      include Api::V1::Defaults

      helpers SessionHelpers


      #Request to see all organizations and information about organizations
        desc "Return all organizations "
        params do

        end
        get "organizations", root: :organization do
        organizations = Organization.all
        render organizations
        end



      end
    end
  end
