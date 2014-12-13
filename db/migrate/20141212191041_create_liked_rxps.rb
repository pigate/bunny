class CreateLikedRxps < ActiveRecord::Migration
  def change
    create_table :liked_rxps do |t|
      t.integer :liked_recipe_id
      t.integer :member_id
      t.index :liked_recipe_id
      t.integer :member_id
      t.timestamps
    end
  end
end
