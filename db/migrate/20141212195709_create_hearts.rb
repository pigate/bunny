class CreateHearts < ActiveRecord::Migration
  def change
    create_table :hearts do |t|
      t.integer :liked_recipe_id
      t.integer :liker_id
      t.index :liked_recipe_id
      t.index :liker_id
      t.timestamps
    end
  end
end
