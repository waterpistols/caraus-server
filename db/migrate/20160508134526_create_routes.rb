class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :name, default: ""
      t.float :start_longitude, default: 0.0
      t.float :start_latitude, default: 0.0

      t.float :destination_longitude, default: 0.0
      t.float :destination_latitude, default: 0.0
      t.text :description
      
      t.string :start_address, default: ""
      t.string :destination_address, default: ""

      t.float :distance, default: 0.0
      t.float :duration, default: 0.0
      t.timestamps null: false
    end
  end
end
