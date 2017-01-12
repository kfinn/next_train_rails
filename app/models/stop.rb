class Stop < ApplicationRecord
  include MtaIdentifiable

  belongs_to :parent_stop, class_name: 'Stop', optional: true
  has_many :child_stops, class_name: 'Stop', foreign_key: :parent_stop_id

  has_many :stop_times
  has_many :trips, -> { distinct }, through: :stop_times
  has_many :routes, -> { distinct }, through: :trips
  has_many :child_stop_routes, -> { distinct }, through: :child_stops, source: :routes

  enum location_type: [:child, :root]

  validates :name, :latitude, :longitude, :location_type, presence: true
  validates :parent_stop, absence: true, if: :root?
  validates :parent_stop, presence: true, if: :child?

  def routes_description
    all_routes.pluck(:mta_id).sort.to_sentence
  end

  def all_routes
    if root?
      child_stop_routes
    else
      routes
    end
  end
end
