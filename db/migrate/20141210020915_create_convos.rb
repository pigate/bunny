class CreateConvos < ActiveRecord::Migration
  def change
    create_table :convos do |t|
      t.integer :conversable_id
      t.string :conversable_type
      t.integer :write_access_level, :default => 2
      t.integer :owner_id, :default => -1

      t.timestamps
    end
  end
end
