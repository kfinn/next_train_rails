class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.references :route, null: false
      t.string :service_id, null: false
      t.string :mta_id, unique: true, null: false
      t.integer :direction_id, null: false

      t.timestamps
    end
  end
end
