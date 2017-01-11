require './lib/config/gtfs_realtime_pb'

class DeparturesCollectionFetch
    FEED_URI = URI("http://datamine.mta.info/mta_esi.php?key=bbd2ce81090cac4aacf4d6ff223b10b3&feed_id=1")

    def departures
      @departures ||= valid_stop_time_updates.map do |stop_time_update|
        Departure.new stop_id: stop_time_update.stop_id, when: Time.at(stop_time_update.departure.time).to_datetime
      end
    end
    alias_method :all, :departures

    def valid_stop_time_updates
      @valid_stop_time_updates ||= feed_message.entity.flat_map do |feed_message|
        if feed_message.trip_update.present?
          feed_message.trip_update.stop_time_update.select do |stop_time_update|
            stop_time_update.stop_id.present? && stop_time_update.departure.present?
          end
        else
          []
        end
      end
    end

    def feed_message
      @feed_message ||= TransitRealtime::FeedMessage.decode api_response
    end

    def api_response
      @api_response ||= Net::HTTP.get(FEED_URI)
    end
end
