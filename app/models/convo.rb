class Convo < ActiveRecord::Base
  belongs_to :conversable, :polymorphic => true 
  has_many :comments, :as => :commentable, :dependent => :destroy
end
