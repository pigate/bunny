require 'aws/s3'

class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :recipes, :foreign_key => :author_id  
  has_many :comments, :foreign_key => :commenter_id
  validates :first, :presence => true
  validates :last, :presence => true
  validates :user_name, :presence => true, uniqueness: { case_sensitive: false }
  validates_format_of :user_name, :with => /[A-Za-z]/
  #devise checks email and password/

  has_many :comments, :as => :commenter
  has_many :posts, :as => :author
  
  has_attached_file :photo,
    :default_url => "missing/:style.png",
    :styles => {
      :original => "140x140#",
      :cropped_thumb => {:geometry => "100x100#", :jcrop => true },
      :tiny_thumb => {:geometry => "32x32#", :jcrop => true}
    },
    :convert_options => {
      :thumb => "-quality 75 -strip"
    },
#    :storage => :s3,
    :bucket => ENV['AWS_BUCKET']
#    :s3_credentials => {
#      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
#      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
#      :bucket => ENV['AWS_BUCKET']
#    },
#    :url => ':s3_domain_url',
#    :path => '/:class/:attachment/:id_partition/:style/:filename'
  
  validates_attachment_content_type :photo, :content_type => /\Aimage/
  validates_attachment_file_name :photo, :matches => [/png\Z/, /PNG\Z/, /jpe?g\Z/, /JPE?G\Z/]

  def slug
    user_name.downcase.gsub(" ", "-")
  end
  def to_param
    "#{slug}"
  end
end
