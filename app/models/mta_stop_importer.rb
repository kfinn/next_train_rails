require 'csv'

class MtaStopImporter
  def import!
    CSV.foreach(MtaDataImporter.mta_data_root + 'stops.csv', headers: true) do |row|
      Stop.find_or_initialize_by_mta_id(row['stop_id']).update!(
        name: row['stop_name'],
        latitude: row['stop_lat'],
        longitude: row['stop_lon'],
        location_type: stop_type_from_row(row),
        parent_stop: parent_stop_from_row(row))
    end
  end

  def stop_type_from_row(row)
    [:child, :root][row['location_type'].to_i]
  end

  def parent_stop_from_row(row)
    if row['parent_station'].present?
      Stop.find_by_mta_id row['parent_station']
    end
  end
end
