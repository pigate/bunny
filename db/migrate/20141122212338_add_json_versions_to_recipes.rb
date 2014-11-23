class AddJsonVersionsToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :j_ingreds, :string
    add_column :recipes, :j_steps, :string
  end
end
