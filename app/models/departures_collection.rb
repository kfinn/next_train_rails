class DeparturesCollection
  include ActiveModel::Model
  include Enumerable

  attr_accessor :updated_at, :departures
  delegate :each, :to_a, to: :departures

  def self.all
    new updated_at: Time.zone.now, departures: DeparturesCollectionFetch.new.all
  end
end
