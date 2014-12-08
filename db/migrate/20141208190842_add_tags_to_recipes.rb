class AddTagsToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :s_tags, :string
  end
end
