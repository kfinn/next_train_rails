class DeparturesCollection
  include ActiveModel::Model

  attr_accessor :updated_at, :departures

  class << self
    def all
      new updated_at: Time.zone.now, departures: DeparturesCollectionFetch.new.all
    end
  end

  def as_json(whatever)
    { updated_at: updated_at, departures: departures }
  end
end
