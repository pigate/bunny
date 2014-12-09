class AddColumnToTags < ActiveRecord::Migration
  def change
    add_column :tags, :hits, :integer, default: 0
  end
end
