class Post < ActiveRecord::Base
  has_one :convo, :as => :conversable, :dependent => :destroy
end
