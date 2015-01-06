class AddTrendLevelToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :trend_level, :decimal, default: 0.0
    add_index :recipes, :trend_level
  end
end
