class AddRealtimeDeparturesToStopTimes < ActiveRecord::Migration[5.0]
  def change
    change_table :stop_times do |t|
      t.datetime :realtime_departure_time
      t.datetime :realtime_departure_time_updated_at
    end
  end
end
