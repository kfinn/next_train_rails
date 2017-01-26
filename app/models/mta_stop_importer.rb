require 'csv'

class MtaStopImporter
  class << self
    attr_accessor :import_started, :import_completed

    def ensure_data_imported
      was_import_started = import_started
      self.import_started = true
      if self.import_completed
        StopTimeCollection.instance.ensure_fresh!
      elsif !was_import_started
        new.import!
        StopTimeCollection.instance.ensure_fresh!
        self.import_completed = true
      end
    end
  end

  def import!
    Rails.logger.info 'MtaStopImporter starting'
    CSV.foreach(ApplicationHelper.mta_data_root + 'stops.csv', headers: true) do |row|
      parent_stop = parent_stop_from_row row
      if parent_stop
        ChildStop.new(
          id: row['stop_id'],
          parent_stop: parent_stop
        ).save
      else
        ParentStop.new(
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
      ParentStop.find row['parent_station']
    end
  end
end
