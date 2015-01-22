class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.boolean :private, default: "true"
      t.integer :member_id
      t.string :name, default: ""
      t.string :description, default: ""
      t.text :list_text, default: ""
      t.integer :view_counts, default: 0
      t.text :recipe_order_array, default: ""
      t.integer :recipe_count, default: 0
      t.integer :type, default: 0

      t.index :member_id
      t.index :view_counts
      t.index :name
      t.index :private, where: "private = false"

      t.timestamps
    end
  end
end
