class AddCompanyIdToSubRecipe < ActiveRecord::Migration[5.2]
  def change
  	add_column :sub_recipes, :company_id, :integer 
  end
end
