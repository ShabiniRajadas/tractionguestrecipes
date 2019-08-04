class CreateSubRecipeIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_recipe_ingredients do |t|
    	t.integer :sub_recipe_id
    	t.integer :ingredient_id
    	t.integer :quantity
      t.timestamps
    end
  end
end
