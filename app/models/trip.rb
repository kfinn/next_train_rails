class Trip < ApplicationRecord
  include MtaIdentifiable

  belongs_to :route
  has_many :stop_times

  validates :service_id, :direction_id, presence: true

  def description
    "{ id: #{id}, route: #{route.mta_id}, direction: #{direction_id} }"
  end


  def self.find_by_mta_id_fragment(mta_id_fragment)
    all_matching_trips = where('mta_id like ?', "%#{mta_id_fragment}%")
    Rails.logger.warn "ambiguous trip fragment: #{mta_id_fragment} might be part of multiple trips: #{all_matching_trips.map(&:description).to_sentence}" if all_matching_trips.count > 1
    all_matching_trips.first
  end
end
