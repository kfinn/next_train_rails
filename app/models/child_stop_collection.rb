class ChildStopCollection
  include Singleton

  def find(id)
    stops_by_id[id]
  end

  def stops_by_id
    MtaStopImporter.ensure_data_imported
    @stops_by_id ||= {}
  end

  def <<(stop)
    stops_by_id[stop.id] = stop
  end
end
