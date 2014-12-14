class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating, default: 1
      t.text :rating_text, default: ''
      t.text :suggestions, default: ''
      t.integer :reviewed_recipe_id
      t.integer :reviewer_id
      t.index :reviewed_recipe_id
      t.index :reviewer_id
      t.integer :helpful_count #used as 'cache' count
      t.boolean :pending, default: true     
      t.timestamps
    end
  end
end
