class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|
      t.integer :joined_group_id
      t.integer :member_id
      t.index :joined_group_id
      t.index :member_id
      t.timestamps
    end
  end
end
