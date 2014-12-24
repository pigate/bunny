class CreateNewsFeeds < ActiveRecord::Migration
  def change
    create_table :news_feeds do |t|
      t.integer :member_id
      t.integer :write_level, default: 7
      t.text :updates, default: ''
      t.index :member_id
      t.timestamps
    end
  end
end
