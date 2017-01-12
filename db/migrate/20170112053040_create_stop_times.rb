class CreateStopTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :stop_times do |t|
      t.references :trip, foreign_key: true
      t.time :arrival_time, null: false
      t.time :departure_time, null: false
      t.references :stop, foreign_key: true

      t.timestamps

      t.index [:trip_id, :stop_id], unique: true
    end
  end
end
