class CreateJwtBlacklists < ActiveRecord::Migration[5.2]
  def change
    create_table :jwt_blacklists do |t|
    	t.string :blacklisted_token
      t.timestamps
    end
  end
end
