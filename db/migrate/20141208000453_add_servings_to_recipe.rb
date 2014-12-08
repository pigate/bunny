class AddServingsToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :servings, :integer, :default => 3
  end
end
