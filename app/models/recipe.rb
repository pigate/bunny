class Recipe < ActiveRecord::Base
  belongs_to :author, :class_name => "Member"
  validates :name, presence: true
  validates_length_of :name, :maximum => 80
  validates :j_ingreds, presence: true
  validates :j_steps, presence: true
  has_many :comments, :through => :convo
  has_many :commenters, :through => :comments, :source => :commenter
  has_one :convo, :as => :conversable, :dependent => :destroy
  has_many :hearts, :foreign_key => :liked_recipe_id
  has_many :likers, :through => :hearts 

  has_many :reviews, :foreign_key => :reviewed_recipe_id, dependent: :destroy
  has_many :reviewers, :through => :reviews

  has_and_belongs_to_many :tags

  has_and_belongs_to_many :lists

  has_attached_file :main_photo,
    :default_url => "missing-recipe/:style.png",
    :styles => {
      :original => "590x405#",
      :cropped_square_thumb => {:geometry => "230x230#", :jcrop => true }
    },
    :convert_options => {
      :thumb => "-quality 75 -strip"
    },
    :storage => :s3,
    :s3_credentials => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :bucket => ENV['AWS_BUCKET']
    },
    :url => ':s3_domain_url',
    :path => '/:class/:attachment/:id_partition/:style/:filename'

  validates_attachment_content_type :main_photo, :content_type => /\Aimage/
  validates_attachment_file_name :main_photo, :matches => [/png\Z/, /PNG\Z/, /jpe?g\Z/, /JPE?G\Z/]

  def slug
    name.downcase.gsub(" ", "-")
  end
  def to_param
    "#{slug}-#{id}"
  end



  def self.parse_params(params)
    params 
  end
end

