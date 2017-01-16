class LatLng
  include ActiveModel::Model
  include Geokit::Mappable

  attr_accessor :latitude, :longitude

  def latitude=(latitude)
    @latitude = latitude.to_f
  end

  def longitude=(longitude)
    @longitude = longitude.to_f
  end

  class << self
    def lat_column_name
      :latitude
    end

    def lng_column_name
      :longitude
    end
  end
end
