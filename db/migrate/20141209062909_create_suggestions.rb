class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.integer :who_id
      t.text :description

      t.timestamps
    end
  end
end
