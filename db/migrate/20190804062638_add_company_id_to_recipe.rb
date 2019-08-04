class AddCompanyIdToRecipe < ActiveRecord::Migration[5.2]
  def change
  	add_column :recipes, :company_id, :integer 
  end
end
