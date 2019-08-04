class CreateSubRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_recipes do |t|
    	t.string :name
    	t.string :description
    	t.decimal :unit_price, precision: 10, null: false
    	t.integer :measurement_unit
 		t.string :image
      t.timestamps
    end
  end
end
