class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.boolean :private, :default => false
      t.integer :owner_id
      t.index :name
      t.index :private
      #let elasticsearch index it
      t.index :owner_id
      t.timestamps
    end
  end
end
