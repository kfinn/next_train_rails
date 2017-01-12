class Trip < ApplicationRecord
  include MtaIdentifiable

  belongs_to :route
  has_many :stop_times

  validates :service_id, :direction_id, presence: true
end
