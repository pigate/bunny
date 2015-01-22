class AddPrivateFieldToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :private, :boolean, default: false
    add_index :recipes, :private, where: "private = false"
  end
end
