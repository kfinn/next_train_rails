class Stop
  include ActiveModel::Model

  attr_accessor :id, :name, :stop_times, :child_stop_ids
  delegate :latitude, :latitude=, :longitude, :longitude=, to: :position

  class << self
    delegate :find, :all, :near, to: :collection

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
    now = TimeOfDay.now
    stop_times.sort_by { |st| st.best_estimate - now }.first
  end
end
