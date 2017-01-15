require 'csv'

class MtaTripImporter
  def import!
    CSV.foreach(ApplicationHelper.mta_data_root + 'trips.csv', headers: true) do |row|
      Trip.new(
        id: id_from_row(row),
        route_id: row['route_id']
      ).save
    end
  end

  def id_from_row(row)
    row['trip_id'].sub("#{row['service_id']}_", '')
  end
end
