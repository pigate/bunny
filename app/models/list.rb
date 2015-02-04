class List < ActiveRecord::Base
  belongs_to :owner, :class_name => "Member"
  has_and_belongs_to_many :recipes
end
