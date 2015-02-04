class RemoveColumnTypeFromLists < ActiveRecord::Migration
  def change
    remove_column :lists, :type
  end
end
