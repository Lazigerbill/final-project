class DropTableAuthentication < ActiveRecord::Migration
  def change
  	drop_table :authentications
  end
end
