class CreateStops < ActiveRecord::Migration[5.0]
  def change
    create_table :stops do |t|
      t.string :mta_id, unique: true, null: false
      t.string :name, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.integer :location_type, null: false
      t.references :parent_stop, foreign_key: true, null: true

      t.timestamps
    end
  end
end
