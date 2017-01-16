class StopTime
  include ActiveModel::Model

  attr_accessor :stop_id, :trip_id, :scheduled, :latest_estimate, :latest_estimate_updated_at

  def self.from(trip_id:, stop_id:)
    StopTimeCollection.instance.find new(trip_id: trip_id, stop_id: stop_id).id
  end

  def save
    StopTimeCollection.instance << self
  end

  def id
    @id ||= "#{stop_id}_#{trip_id}"
  end

  def stop_id=(stop_id)
    if self.stop_id
      Stop.find(@stop_id).stop_times.select! { |stop_time| stop_time != self }
    end
    @stop_id = stop_id
    Stop.find(stop_id).stop_times << self
  end

  def scheduled=(scheduled)
    @scheduled = TimeOfDay.from_datetime scheduled
  end

  def latest_estimate=(latest_estimate)
    @latest_estimate = TimeOfDay.from_datetime latest_estimate
    self.latest_estimate_updated_at = Time.zone.now
  end

  def route_id
    @route_id ||= trip_id.sub(/^[^_]+_/, '').sub(/\.\..*$/, '')
  end

  def best_estimate
    if latest_estimate && latest_estimate_updated_at > 6.hours.ago
      latest_estimate
    else
      scheduled
    end
  end
end
