require './lib/config/gtfs_realtime_pb'

class StopTimesUpdate
  FEED_URI = URI("http://datamine.mta.info/mta_esi.php?key=bbd2ce81090cac4aacf4d6ff223b10b3&feed_id=1")

  attr_accessor :updated_stop_times

  def notify!
    update_stop_times!
    updated_stop_times.each do |updated_stop|
      StopChannel.broadcast_to updated_stop
    end
  end

  def update_stop_times!
    self.updated_stop_times ||= valid_trip_updates.each_with_object(Set.new) do |trip_update, updated_stops|
     trip_update.stop_time_update.map do |stop_time_update|
       next unless stop_time_update.stop_id.present? && stop_time_update.departure.present?

       stop_time = StopTime.find_or_create_by(trip_id: trip_update.trip.trip_id, stop_id: stop_time_update.stop_id)
       stop_time.latest_estimate = Time.zone.at(stop_time_update.departure.time)

       updated_stops << stop_time.stop
     end
   end
  end

  def valid_trip_updates
    feed_message.entity.select do |feed_message|
      feed_message.trip_update.present? &&
      feed_message.trip_update.trip.present? &&
      feed_message.trip_update.trip.trip_id.present?
    end.map &:trip_update
  end

  def feed_message
    TransitRealtime::FeedMessage.decode api_response
  end

  def api_response
    Net::HTTP.get(FEED_URI)
  end
end
