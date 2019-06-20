module Api
  module V1
    class Organizations < Grape::API
      include Api::V1::Defaults

      helpers SessionHelpers



        desc "Return a organizations of current  driver"
        params do

        end
        get "organizations", root: :organization do
        organizations = Organization.all
        render organizations
        end



      end
    end
  end
