class CreateListsRecipes < ActiveRecord::Migration
  def change
    create_table :lists_recipes do |t|
      t.integer :list_id 
      t.integer :recipe_id
      t.index :list_id
      t.index :recipe_id
      t.index [:list_id, :recipe_id], unique: true

      t.timestamps
    end
  end
end
