class StopTimeCollection
  include Singleton

  def ensure_data_imported
    was_imported = @ensure_data_imported
    @ensure_data_imported = true
    MtaStopTimeImporter.new.import! unless was_imported
  end

  def <<(stop_time)
    stop_times_by_id[stop_time.id] = stop_time
  end

  def stop_times_by_id
    @stop_times_by_id ||= {}
  end
end
