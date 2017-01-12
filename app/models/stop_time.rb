class StopTime < ApplicationRecord
  belongs_to :trip
  belongs_to :stop

  validate :must_be_unique
  validates :arrival_time, :departure_time, presence: true

  private

  def must_be_unique
    errors.add(:trip_and_stop, 'must be unique') if conflicting_stop_times_exist?
  end

  def conflicting_stop_times_exist?
    cst = conflicting_stop_times
    cst.count > 1 || (cst.count == 1 && cst.first != self)
  end

  def conflicting_stop_times
    StopTime.where(trip: trip, stop: stop)
  end
end
