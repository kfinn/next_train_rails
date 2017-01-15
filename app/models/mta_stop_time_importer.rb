require 'csv'

class MtaStopTimeImporter
  def import!
    Rails.logger.info 'MtaStopTimeImporter starting'
    CSV.foreach(ApplicationHelper.mta_data_root + 'stop_times.csv', headers: true) do |row|
      StopTime.new(
        trip_id: row['trip_id'].sub(/^[^_]+_/, ''),
        stop_id: row['stop_id'],
        scheduled: Time.zone.parse(adjust_invalid_datetime(row['departure_time']))
      ).save
    end
    Rails.logger.info 'MtaStopTimeImporter done'
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
