class ChildStop
  include ActiveModel::Model

  attr_accessor :id, :parent_stop

  class << self
    delegate :find, to: :collection

    def collection
      ChildStopCollection.instance
    end
  end

  def save
    ChildStop.collection << self
  end

  def parent_stop=(parent_stop)
    if @parent_stop
      @parent_stop.remove_child_stop self
    end
    @parent_stop = parent_stop
    if parent_stop
      parent_stop.add_child_stop self
    end
  end

  def stop_times
    @stop_times ||= []
  end

  def next_stop_time
    now = Time.zone.now
    stop_times.select do |st|
      st.latest_estimate.present? && st.latest_estimate > (now + 1.minute)
    end.sort_by do |st|
      st.latest_estimate - now
    end.first
  end

  def direction
    id.last
  end
end
