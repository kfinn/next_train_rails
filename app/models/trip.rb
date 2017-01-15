class Trip
  include ActiveModel::Model

  attr_accessor :id, :route_id

  def self.find(id)
    TripCollection.instance.find(id)
  end

  def save
    TripCollection.instance << self
  end
end
