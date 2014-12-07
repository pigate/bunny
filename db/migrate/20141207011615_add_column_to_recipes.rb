class AddColumnToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :totalTime, :integer, default: 10
  end
end
