class AddAttachmentMainPhotoToRecipes < ActiveRecord::Migration
  def self.up
    change_table :recipes do |t|
      t.attachment :main_photo
    end
  end

  def self.down
    remove_attachment :recipes, :main_photo
  end
end
