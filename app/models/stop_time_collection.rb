class StopTimeCollection
  include Singleton

  attr_accessor :updated_at

  def ensure_fresh!
    return if fresh?
    self.updated_at = Time.zone.now
    StopTimesUpdate.new.update_stop_times!
  end

  def find(id)
    stop_times_by_id[id]
  end

  def <<(stop_time)
    stop_times_by_id[stop_time.id] = stop_time
    updated_at = Time.zone.now
  end

  def stop_times_by_id
    @stop_times_by_id ||= {}
  end

  def fresh?
    updated_at && updated_at > 15.seconds.ago
  end
end
