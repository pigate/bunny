class AddIndexOwnerAndNameLists < ActiveRecord::Migration
  def change
    add_index :lists, ["owner_id", "name"], unique: true 
  end
end
