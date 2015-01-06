class RemoveDescriptionFromTagTypes < ActiveRecord::Migration
  def change
    remove_column :tag_types, :description
    remove_column :tag_types, :approved
    remove_column :tag_types, :submitter_id
  end
end
