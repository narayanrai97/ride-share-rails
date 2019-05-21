module Api
  module V1
    module RideHelpers
      extend Grape::API::Helpers

      def check_radius(start_location, stop_location, home, radius)
        start_coordinates = Geocoder.search(start_location).first.coordinates
        stop_coordinates = Geocoder.search(stop_location).first.coordinates
        home_coordinates = Geocoder.search(home).first.coordinates
        distance1 = Geocoder::Calculations.distance_between(start_coordinates, home_coordinates)
        distance2 = Geocoder::Calculations.distance_between(stop_coordinates, stop_coordinates)
        if distance1 <= radius and distance2<= radius
          return true
        end
        return false
      end



    end
  end
end
