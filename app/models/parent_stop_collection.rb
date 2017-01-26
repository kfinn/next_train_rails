class ParentStopCollection
  include Singleton

  def find(id)
    stops_by_id[id]
  end

  def all
    MtaStopImporter.ensure_data_imported
    @all ||= Set.new
  end

  def stops_by_id
    MtaStopImporter.ensure_data_imported
    @stops_by_id ||= {}
  end

  def visible
    all.select do |stop|
      stop.next_n_stop_time.present? || stop.next_s_stop_time.present?
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
  end
end
