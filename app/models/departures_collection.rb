class DeparturesCollection
  include ActiveModel::Model

  attr_accessor :updated_at, :departures

  class << self
    def all
      if @all && @all.fresh?
        @all
      else
        @all = fetch
      end
    end

    private

    def fetch
      new updated_at: Time.zone.now, departures: DeparturesCollectionFetch.new.all
    end
  end

  def fresh?
    updated_at > 1.minute.ago
  end

  def as_json(whatever)
    { updated_at: updated_at, departures: departures }
  end
end
