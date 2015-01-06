class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :member_id
      t.text :recs_list, default: ''
      t.index :member_id
      t.timestamps
    end
  end
end
