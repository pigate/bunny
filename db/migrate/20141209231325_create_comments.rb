class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment_text
      t.integer :commentable_id
      t.string :commentable_type
      t.integer :commenter_id, :default => -1
      t.timestamps
    end
  end
end
