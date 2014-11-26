class ChangeRecipeStringTypeToText < ActiveRecord::Migration
  def change
    change_column :recipes, :ingreds, :text
    change_column :recipes, :j_ingreds, :text
    change_column :recipes, :steps, :text
    change_column :recipes, :j_steps, :text
  end
end
