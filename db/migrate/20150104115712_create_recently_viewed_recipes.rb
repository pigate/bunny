class CreateRecentlyViewedRecipes < ActiveRecord::Migration
  def change
    create_table :recently_viewed_recipes do |t|
      t.integer :member_id
      t.text :recently_viewed_list, default: ''
      t.index :member_id
      t.timestamps
    end
  end
end
