class AddViewsToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :global_views, :integer, default: 0
    add_index :recipes, :global_views
  end
end
