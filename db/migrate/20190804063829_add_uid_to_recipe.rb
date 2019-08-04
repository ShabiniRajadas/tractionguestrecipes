class AddUidToRecipe < ActiveRecord::Migration[5.2]
  def change
  	add_column :recipes, :uid, :string 
  end
end
