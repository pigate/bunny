class CreateGroupPosts < ActiveRecord::Migration
  def change
    create_table :group_posts do |t|
      t.integer :group_id
      t.integer :post_id
      t.index :group_id
      t.index :post_id
      t.timestamps
    end
  end
end
