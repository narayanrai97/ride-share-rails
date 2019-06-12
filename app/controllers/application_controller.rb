class ApplicationController < ActionController::Base
	def after_sign_in_path_for(resource)

		if resource.class == User
		stored_location_for(resource) || welcome_index_path
		else
		stored_location_for(resource) || welcome_rider_path
		end

	end


	def after_sign_out_path_for(resource)
		root_path
	end



end
