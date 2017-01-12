class AddIndicesWhereNeeded < ActiveRecord::Migration[5.0]
  def change
    add_index :routes, :mta_id
    add_index :stop_times, :departure_time
    add_index :stop_times, :realtime_departure_time
    add_index :stops, :mta_id
    add_index :trips, :mta_id
  end
end
