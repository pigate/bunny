class CreateTagHits < ActiveRecord::Migration
  def change
    create_table :tag_hits do |t|
      t.integer :member_id

      t.integer :views, default: 0 #how many recipes user has viewed. Used to tell when to refresh the counts and percentages

      t.integer  "chinese_count", default: 0
      t.integer  "american_count", default: 0
      t.integer  "hack_count", default: 0
      t.integer  "easy_count", default: 0
      t.integer  "average_count", default: 0
      t.integer  "difficult_count", default: 0
      t.integer  "lazy_count", default: 0

      t.decimal  "chinese_count_percent", default: 0.0
      t.decimal  "american_count_percent", default: 0.0
      t.decimal  "hack_count_percent", default: 0.0
      t.decimal  "easy_count_percent", default: 0.0
      t.decimal  "average_count_percent", default: 0.0
      t.decimal  "difficult_count_percent", default: 0.0
      t.decimal  "lazy_count_percent", default: 0.0

      t.index :member_id
      t.timestamps
    end
  end
end
