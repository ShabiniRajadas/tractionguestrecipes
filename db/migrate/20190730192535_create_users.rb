class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
    	t.string :email, null: false
    	t.string :password
    	t.string :password_confirmation
    	t.string :name
    	t.integer :status, default: 1
    	t.integer :company_id
      t.timestamps
    end
  end
end
