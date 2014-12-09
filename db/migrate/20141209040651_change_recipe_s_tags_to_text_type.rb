class ChangeRecipeSTagsToTextType < ActiveRecord::Migration
  def change
    change_column :recipes, :s_tags, :text, default: ""
  end
end
