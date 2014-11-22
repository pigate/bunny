class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :first
      t.string :last
      t.string :user_name
      t.string :occupation
      t.boolean :admin, default: false
      t.timestamps
    end
  end
end
