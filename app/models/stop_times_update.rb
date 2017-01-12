require './lib/config/gtfs_realtime_pb'

class StopTimesUpdate
  FEED_URI = URI("http://datamine.mta.info/mta_esi.php?key=bbd2ce81090cac4aacf4d6ff223b10b3&feed_id=1")

  def update_stop_times!
    valid_trip_updates.flat_map do |trip_update|
      trip_update.stop_time_update.each do |stop_time_update|
        next unless stop_time_update.stop_id.present? && stop_time_update.departure.present?

        stop_time = StopTime.find_or_initialize_by(
          trip: Trip.find_by_mta_id_fragment(trip_update.trip.trip_id),
          stop: Stop.find_by_mta_id(stop_time_update.stop_id)
        ).update!(
          realtime_departure_time: Time.zone.at(stop_time_update.departure.time).to_datetime,
          realtime_departure_time_updated_at: Time.zone.now
        )
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
