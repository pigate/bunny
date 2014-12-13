class Heart < ActiveRecord::Base
  belongs_to :liked_recipe, :class_name => "Recipe"
  belongs_to :liker, :class_name => "Member"
end
