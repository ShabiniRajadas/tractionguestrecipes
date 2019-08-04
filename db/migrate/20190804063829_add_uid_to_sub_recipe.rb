class AddUidToSubRecipe < ActiveRecord::Migration[5.2]
  def change
  	add_column :sub_recipes, :uid, :string 
  end
end
