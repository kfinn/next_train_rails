class StopTime
  include ActiveModel::Model

  attr_accessor :stop_id, :trip_id, :latest_estimate, :latest_estimate_updated_at
  delegate :parent_stop, to: :child_stop

  def self.find_or_create_by(trip_id:, stop_id:)
    StopTimeCollection.instance.find(new(trip_id: trip_id, stop_id: stop_id).id) || new(trip_id: trip_id, stop_id: stop_id).tap(&:save)
  end

  def save
    StopTimeCollection.instance << self
  end

  def id
    @id ||= "#{stop_id}_#{trip_id}"
  end

  def child_stop
    ChildStop.find stop_id
  end

  def stop_id=(stop_id)
    if @stop_id
      child_stop.stop_times.select! { |stop_time| stop_time != self }
    end
    @stop_id = stop_id
    child_stop.stop_times << self
  end

  def latest_estimate=(latest_estimate)
    @latest_estimate = latest_estimate
    self.latest_estimate_updated_at = Time.zone.now
  end

  def route_id
    @route_id ||= trip_id.sub(/^[^_]+_/, '').sub(/\.\..*$/, '')
  end

  def as_json(options={})
    {
      route_id: route_id,
      latest_estimate: latest_estimate.to_datetime,
      latest_estimate_updated_at: latest_estimate_updated_at
    }
  end
end
