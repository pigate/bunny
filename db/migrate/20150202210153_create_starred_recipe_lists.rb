class CreateStarredRecipeLists < ActiveRecord::Migration
  def change
    create_table :starred_recipe_lists do |t|
      t.integer :member_id
      t.text :saved_recipes_array, default: ""

      t.timestamps
      t.index :member_id
    end
  end
end
