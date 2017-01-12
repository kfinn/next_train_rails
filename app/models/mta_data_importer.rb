class MtaDataImporter
  def self.mta_data_root
    Rails.root + 'config/mta_data'
  end

  def import!
    MtaStopImporter.new.import!
    MtaRouteImporter.new.import!
    MtaTripImporter.new.import!
    MtaStopTimeImporter.new.import!
  end
end
