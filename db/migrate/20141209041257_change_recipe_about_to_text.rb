class ChangeRecipeAboutToText < ActiveRecord::Migration
  def change
    change_column :recipes, :about, :text, default: ""
  end
end
