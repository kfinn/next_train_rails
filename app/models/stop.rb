class Stop
  include ActiveModel::Model

  attr_accessor :id, :name, :stop_times, :child_stop_ids
  delegate :latitude, :latitude=, :longitude, :longitude=, to: :position

  class << self
    delegate :find, :all, :visible, :near, to: :collection

    private

    def collection
      StopCollection.instance
    end
  end

  def save
    StopCollection.instance << self
  end

  def position
    @position ||= LatLng.new
  end

  def routes_summary
    @routes_summary ||= stop_times.map(&:route_id).uniq.sort.to_sentence
  end

  def stop_times
    @stop_times ||= []
  end

  def child_stop_ids
    @child_stop_ids ||=[]
  end

  def next_stop_time
    now = Time.zone.now
    stop_times.select do |st|
      st.latest_estimate.present? && st.latest_estimate > (now + 1.minute)
    end.sort_by do |st|
      st.latest_estimate - now
    end.first
  end

  def as_json(options={})
    {
      id: self.id,
      name: self.name,
      routes_summary: self.routes_summary,
      next_stop_time: next_stop_time.as_json
    }
  end
end
