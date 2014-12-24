class ChangeColumnMembers < ActiveRecord::Migration
  def change
    change_column :members, :user_name, :string, :default => 'LOL'
  end
end
