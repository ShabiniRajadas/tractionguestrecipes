class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
    	t.string :uid, null: false
    	t.string :name
    	t.string :url
    	t.string :description
    	t.string :image
      t.timestamps
    end
  end
end
