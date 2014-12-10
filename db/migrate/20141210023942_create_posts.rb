class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :author_id
      t.integer :feed_id
      t.text :post_text
      t.text :s_tags

      t.timestamps
    end
  end
end
