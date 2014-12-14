class Review < ActiveRecord::Base
  belongs_to :reviewer, class_name: "Member"
  belongs_to :reviewed_recipe, class_name:"Recipe"
  validates_inclusion_of :rating, :in => 1..5 #0 is not finished
end
