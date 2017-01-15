class Stop
  include ActiveModel::Model

  attr_accessor :id, :name, :latitude, :longitude, :stop_times, :child_stop_ids

  class << self
    delegate :find, :all, to: :collection

    private

    def collection
      StopCollection.instance
    end
  end

  def save
    StopCollection.instance << self
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
end
