class ChangeRecipeTimesAndAddCookTime < ActiveRecord::Migration
  def change
    rename_column :recipes, :totalTime, :prep_time
    add_column :recipes, :cook_time, :integer, default: 10
  end
end
