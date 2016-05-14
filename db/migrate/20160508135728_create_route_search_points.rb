class CreateRouteSearchPoints < ActiveRecord::Migration
  def change
    create_table :route_search_points do |t|
      t.float :longitude, default: 0.0
      t.float :latitude, default: 0.0

      t.integer :route_id, default: 0
      t.timestamps null: false
    end
  end
end
