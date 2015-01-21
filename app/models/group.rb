class Group < ActiveRecord::Base
  belongs_to :owner, :class_name => "Group"
  has_many :group_memberships, foreign_key: "joined_group_id"
  has_many :members, :through => :group_memberships
  has_and_belongs_to_many :posts
  has_many :group_posts
  has_many :posts, through: :group_posts
  validates :name, :uniqueness => true
  def slug
    name.downcase.gsub(" ","-")
  end

  def self.parse_params(params)
    params
  end
end

