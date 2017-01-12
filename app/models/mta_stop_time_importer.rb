require 'csv'

class MtaStopTimeImporter
  def import!
    CSV.foreach(MtaDataImporter.mta_data_root + 'stop_times.csv', headers: true) do |row|
      begin
        StopTime.find_or_initialize_by(
          trip: trip_from_row(row),
          stop: stop_from_row(row)
        ).update!(
          arrival_time: adjust_invalid_datetime(row['arrival_time']),
          departure_time: adjust_invalid_datetime(row['departure_time'])
        )
      rescue StandardError => e
        binding.pry
        raise e
      end
    end
  end

  def trip_from_row(row)
    Trip.find_by_mta_id row['trip_id']
  end

  def stop_from_row(row)
    Stop.find_by_mta_id row['stop_id']
  end

  def adjust_invalid_datetime(time)
    hour = time[0..1].to_i
    if hour > 23
      (hour - 24).to_s + time[2..-1]
    else
      time
    end
  end
end
