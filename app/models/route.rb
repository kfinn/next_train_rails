class Route < ApplicationRecord
  include MtaIdentifiable

  has_many :trips

  validates :short_name, :long_name, :description, :url, presence: true
end
