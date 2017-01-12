require 'csv'

class MtaTripImporter
  def import!
    CSV.foreach(MtaDataImporter.mta_data_root + 'trips.csv', headers: true) do |row|
      Trip.find_or_initialize_by_mta_id(row['trip_id']).update!(
        service_id: row['service_id'],
        direction_id: row['direction_id'],
        route: route_from_row(row))
    end
  end

  def route_from_row(row)
    Route.find_by_mta_id row['route_id']
  end
end
