class TripCollection
  include Singleton

  def ensure_data_imported
    was_imported = @ensure_data_imported
    @ensure_data_imported = true
    MtaTripImporter.new.import! unless was_imported
  end

  def find(id)
    ensure_data_imported
    trips_by_id[id]
  end

  def <<(trip)
    trips_by_id[trip.id] = trip
  end

  def trips_by_id
    @trips_by_id ||= {}
  end
end
