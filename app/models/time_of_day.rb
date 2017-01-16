class TimeOfDay
  include ActiveModel::Model

  SECONDS_PER_DAY = 86400

  attr_accessor :offset

  class << self
    def from_datetime(datetime)
      new offset: datetime.seconds_since_midnight
    end

    def now
      from_datetime Time.zone.now
    end
  end

  def -(other)
    (offset - other.offset) % SECONDS_PER_DAY
  end

  def to_date
    Time.zone.now.beginning_of_day + offset.seconds
  end
end
