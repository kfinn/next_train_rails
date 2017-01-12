require 'csv'

class MtaRouteImporter
  def import!
    CSV.foreach(MtaDataImporter.mta_data_root + 'routes.csv', headers: true) do |row|
      Route.find_or_initialize_by_mta_id(row['route_id']).update!(
        short_name: row['route_short_name'],
        long_name: row['route_long_name'],
        description: row['route_desc'],
        url: row['route_url'],
        color: row['route_color'],
        text_color: row['route_text_color'])
    end
  end
end
