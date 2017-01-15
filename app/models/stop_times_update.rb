require './lib/config/gtfs_realtime_pb'

class StopTimesUpdate
  FEED_URI = URI("http://datamine.mta.info/mta_esi.php?key=bbd2ce81090cac4aacf4d6ff223b10b3&feed_id=1")

  def update_stop_times!
    valid_trip_updates.flat_map do |trip_update|
      trip_update.stop_time_update.each do |stop_time_update|
        next unless stop_time_update.stop_id.present? && stop_time_update.departure.present?

        args = { trip_id: trip_update.trip.trip_id, stop_id: stop_time_update.stop_id }
        stop_time = StopTime.from(args) || StopTime.new(args).tap(&:save)
        stop_time.latest_estimate = Time.zone.at(stop_time_update.departure.time).to_datetime
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
