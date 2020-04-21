class Geodistance
  include Math
  attr_reader :from, :to, :lat1, :lon1, :lat2, :lon2
  RADIUS = 6371

  def initialize(from, to)
    @from = from
    @to = to
    set_variables
  end

  def calculate_distance(type = 'cosines')
    begin
      self.send(type.to_sym)
    rescue
      raise NotImplementedError, 'The type you have requested is not implemented, try "haversine" or "approximation", or without params for "cosines"'
    end
  end




  private
    def cosines
      acos(sin(lat1) * sin(lat2) +
           cos(lat1) * cos(lat2) *
           cos(lon2 - lon1)) * RADIUS
    end

    def to_rad(coordinate)
      coordinate / 180 * Math::PI
    end

    def set_variables
      @lat1 = to_rad(from[:latitude])
      @lat2 = to_rad(to[:latitude])
      @lon1 = to_rad(from[:longitude])
      @lon2 = to_rad(to[:longitude])
    end
end
