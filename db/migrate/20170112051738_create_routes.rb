class CreateRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :routes do |t|
      t.string :mta_id, unique: true, null: false
      t.string :short_name, null: false
      t.string :long_name, null: false
      t.text :description, null: false
      t.string :url, null: false
      t.string :color
      t.string :text_color

      t.timestamps
    end
  end
end
