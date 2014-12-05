class CreateTagTypes < ActiveRecord::Migration
  def change
    create_table :tag_types do |t|
      t.string :name
      t.string :description
      t.boolean :approved, :default => false
      t.integer :submitter_id
      t.timestamps
    end
  end
end
