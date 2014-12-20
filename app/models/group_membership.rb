class GroupMembership < ActiveRecord::Base
  belongs_to :joined_group, class_name: "Group"
  belongs_to :member
  validates :joined_group_id, presence: true
  validates :member_id, presence: true
  validates :member_id, :uniqueness => { :scope => :joined_group_id }
end
