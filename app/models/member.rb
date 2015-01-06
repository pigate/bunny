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
  validates :user_name, :presence => true, length: { minimum: 1, maximum: 30}, uniqueness: { case_sensitive: false }
  validates_format_of :user_name, :with => /[A-Za-z]/
  #devise checks email and password/

  has_many :comments, :as => :commenter
  has_many :posts, :as => :author
  has_many :hearts, :foreign_key => :liker_id, dependent: :destroy
  has_many :liked_recipes, through: :hearts
  has_many :reviews, :foreign_key => :reviewer_id
  has_many :reviewed_recipes, :through => :reviews

#  has_many :pending_friend_requests
#  has_many :initiators, through: :pending_friend_requests
  has_many :active_relationships, class_name: "Relationship",
                  foreign_key: "follower_id",
                  dependent: :destroy
  #has_many :followers, through: :active_relationships, source: :followed   
  has_many :following, through: :active_relationships, source: :followed 
  has_many :passive_relationships, class_name: "Relationship",
                  foreign_key: "followed_id",
                  dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :groups, foreign_key: "owner_id"
  has_many :group_memberships, dependent: :destroy
  has_many :joined_groups, through: :group_memberships  

  has_one :news_feed, dependent: :destroy

  #analytics
  has_one :recently_viewed_recipes
  has_one :tag_hits
  has_one :recommendation
 
  has_attached_file :photo,
    :dependent => :destroy,
    :default_url => "missing/:style.png",
    :styles => {
      :original => "140x140#",
      :cropped_thumb => {:geometry => "100x100#", :jcrop => true },
      :tiny_thumb => {:geometry => "32x32#", :jcrop => true}
    },
    :convert_options => {
      :thumb => "-quality 75 -strip"
    },
    :bucket => ENV['AWS_BUCKET']
  
  validates_attachment_content_type :photo, :content_type => /\Aimage/
  validates_attachment_file_name :photo, :matches => [/png\Z/, /PNG\Z/, /jpe?g\Z/, /JPE?G\Z/]

  def slug
    user_name.downcase.gsub(" ", "-")
  end
  def to_param
    "#{slug}"
  end
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  def self.parse_params(params)
    params
  end
  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: parse_params(query),
            fields: ['user_name^2', 'first', 'last', 'email'],
            operator: "and"
          }
        }
      }
    )
  end
end

Member.__elasticsearch__.client.indices.delete index: Member.index_name rescue nil
#
Member.__elasticsearch__.client.indices.create index: Member.index_name,
  body: { settings: Member.settings.to_hash, mappings: Member.mappings.to_hash }

Member.import #to auto sync model with elastic search

