class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :recipes, :foreign_key => :author_id  
  validates :first, :presence => true
  validates :last, :presence => true
  validates :user_name, :presence => true, uniqueness: { case_sensitive: false }
  #devise checks email and password
end
