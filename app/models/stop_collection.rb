class StopCollection
  include Singleton

  attr_accessor :import_started, :import_completed

  def ensure_data_imported
    was_import_started = import_started
    self.import_started = true
    if self.import_completed
      StopTimeCollection.instance.ensure_fresh!
    elsif !was_import_started
      MtaStopImporter.new.import!
      StopTimeCollection.instance.ensure_fresh!
      self.import_completed = true
    end
  end

  def find(id)
    ensure_data_imported
    stops_by_id[id]
  end

  def all
    ensure_data_imported
    @all ||= Set.new
  end

  def visible
    all.select do |stop|
      stop.next_stop_time.present?
    end
  end

  def near(position)
    visible.sort_by do |stop|
      stop.position.distance_to position, formula: :flat
    end
  end

  def <<(stop)
    all << stop
    stops_by_id[stop.id] = stop
    stop.child_stop_ids.each do |child_stop_id|
      stops_by_id[child_stop_id] = stop
    end
  end

  def stops_by_id
    @stops_by_id ||= {}
  end
end
