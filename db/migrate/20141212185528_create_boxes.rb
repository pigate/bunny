class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.integer :member_id

      t.timestamps
    end
  end
end
