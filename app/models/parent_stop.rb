class ParentStop
  include ActiveModel::Model

  attr_accessor :id, :name, :n_child_stop, :s_child_stop
  delegate :latitude, :latitude=, :longitude, :longitude=, to: :position

  class << self
    delegate :find, :all, :visible, :near, to: :collection

    def collection
      ParentStopCollection.instance
    end
  end

  def save
    ParentStop.collection << self
  end

  def routes_summary
    @routes_summary ||= stop_times.map(&:route_id).uniq.sort.to_sentence
  end

  def next_n_stop_time
    n_child_stop.next_stop_time
  end

  def next_s_stop_time
    s_child_stop.next_stop_time
  end

  def stop_times
    child_stops.flat_map &:stop_times
  end

  def position
    @position ||= LatLng.new
  end

  def add_child_stop(child_stop)
    if child_stop.direction == 'N'
      self.n_child_stop = child_stop
    else
      self.s_child_stop = child_stop
    end
  end

  def remove_child_stop(child_stop)
    if child_stop.direction == 'N'
      self.n_child_stop = nil
    else
      self.s_child_stop = child_stop
    end
  end

  def child_stops
    [n_child_stop, s_child_stop].compact
  end

  def as_json(options={})
    {
      id: self.id,
      name: self.name,
      routes_summary: self.routes_summary,
    }.tap do |json|
      json[:next_n_stop_time] = next_n_stop_time.as_json if next_n_stop_time
      json[:next_s_stop_time] = next_s_stop_time.as_json if next_s_stop_time
    end
  end
end
