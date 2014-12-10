class RemoveColumnFromPost < ActiveRecord::Migration
  def change
    remove_column :posts, :feed_id, :integer
  end
end
