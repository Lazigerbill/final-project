class ChangeUserIdToBigInt < ActiveRecord::Migration
  def change
  	remove_column :tweets, :user_id
  	add_column :tweets, :user_id, :bigint
  end
end
