class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.belongs_to :tag_type
      t.timestamps
    end
  end
end
