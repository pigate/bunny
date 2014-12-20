class AddCachedRatingToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :cached_rating, :float, :default => 0.00
    add_column :recipes, :num_reviews, :integer, :default => 0
    add_index :recipes, :cached_rating
    add_index :recipes, :num_reviews
  end
end
