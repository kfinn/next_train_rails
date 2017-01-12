class Stop < ApplicationRecord
  include MtaIdentifiable

  belongs_to :parent_stop, class_name: 'Stop', optional: true
  has_many :stop_times

  enum location_type: [:child, :root]

  validates :name, :latitude, :longitude, :location_type, presence: true
  validates :parent_stop, absence: true, if: :root?
  validates :parent_stop, presence: true, if: :child?
end
