class RenameMemberIdToOwnerIdLists < ActiveRecord::Migration
  def change
    rename_column :lists, :member_id, :owner_id
  end
end
