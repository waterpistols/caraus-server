class CreateCompanyDetails < ActiveRecord::Migration
  def change
    create_table :company_details do |t|

      t.timestamps null: false
    end
  end
end
