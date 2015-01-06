class CreateRecipesTags < ActiveRecord::Migration
  def change
    create_table :recipes_tags do |t|
      t.integer :recipe_id
      t.integer :tag_id
      t.index :recipe_id
      t.index :tag_id
      t.index [:recipe_id, :tag_id], :unique => true
      t.index [:tag_id, :recipe_id], :unique => true
    end
  end
end
