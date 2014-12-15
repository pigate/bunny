class AddCachedFollowingCountToMembers < ActiveRecord::Migration
  def change
    add_column :members, :following_count, :integer, :default => 0
    add_column :members, :follower_count, :integer, :default => 0
  end
end
