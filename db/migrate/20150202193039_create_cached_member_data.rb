class CreateCachedMemberData < ActiveRecord::Migration
  def change
    create_table :cached_member_data do |t|
      t.integer :member_id
      t.text :saved_recipes_array, :default => ""

      t.timestamps
      t.index :member_id
    end
  end
end
