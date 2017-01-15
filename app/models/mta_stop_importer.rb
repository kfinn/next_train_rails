require 'csv'

class MtaStopImporter
  def import!
    Rails.logger.info 'MtaStopImporter starting'
    CSV.foreach(ApplicationHelper.mta_data_root + 'stops.csv', headers: true) do |row|
      if row['parent_station']
        parent_station = parent_stop_from_row row
        parent_station.child_stop_ids << row['stop_id']
        parent_station.save
      else
        Stop.new(
          id: row['stop_id'],
          name: row['stop_name'],
          latitude: row['stop_lat'],
          longitude: row['stop_lon']
        ).save
      end
    end
    Rails.logger.info 'MtaStopImporter done'
  end

  def parent_stop_from_row(row)
    if row['parent_station'].present?
      Stop.find row['parent_station']
    end
  end
end
