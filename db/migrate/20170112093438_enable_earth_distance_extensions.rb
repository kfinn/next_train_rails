class EnableEarthDistanceExtensions < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'cube'
    enable_extension 'earthdistance'
  end
end
