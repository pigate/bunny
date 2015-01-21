class Post < ActiveRecord::Base
  has_one :convo, :as => :conversable, :dependent => :destroy
  has_many :group_posts
  has_many :groups, through: :group_posts
  validates :photo, :presence => true

  has_attached_file :photo,
    :default_url => "missing-post/:style.png",
    :styles => {
      :original => "407x407#",
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

  belongs_to :author, :class_name => "Member"
  validates_attachment_content_type :photo, :content_type => /\Aimage/
  validates_attachment_file_name :photo, :matches => [/png\Z/, /PNG\Z/, /jpe?g\Z/, /JPE?G\Z/]
#  include Tire::Model::Search
#  include Tire::Model::Callbacks
  def self.parse_params(params)
    params
  end
end



