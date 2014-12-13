class Box < ActiveRecord::Base
  #has_many :saved_recipes, :through => :saved_rxp
  has_many :liked_recipes, :through => :saved_rxp
end
