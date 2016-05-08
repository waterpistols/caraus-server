class CreateRouteSearchPoints < ActiveRecord::Migration
  def change
    create_table :route_search_points do |t|
      t.decimal :longitude, default: 0.0
      t.decimal :latitude, default: 0.0

      t.integer :route_id, default: 0
      t.timestamps null: false
    end
  end
end
