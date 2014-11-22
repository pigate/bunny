class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :about
      t.string :ingreds
      t.string :steps
      t.integer :author_id

      t.timestamps
    end
  end
end
