class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
    	t.string :name
    	t.string :description
    	t.string :uid
    	t.integer :measurement_unit
    	t.decimal :unit_price, precision: 10, null: false
    	t.integer :company_id
      t.timestamps
    end
  end
end
