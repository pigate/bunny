require 'elasticsearch/model'
class Recipe < ActiveRecord::Base
  belongs_to :author, :class_name => "Member"
  validates :name, presence: true
  validates :j_ingreds, presence: true
  validates :j_steps, presence: true
  has_many :comments, :through => :convo
  has_many :commenters, :through => :comments, :source => :commenter
  has_one :convo, :as => :conversable, :dependent => :destroy


  has_attached_file :main_photo,
    :default_url => "missing-recipe/:style.png",
    :styles => {
      :original => "590x405#",
      :cropped_square_thumb => {:geometry => "230x230#", :jcrop => true }
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

  validates_attachment_content_type :main_photo, :content_type => /\Aimage/
  validates_attachment_file_name :main_photo, :matches => [/png\Z/, /PNG\Z/, /jpe?g\Z/, /JPE?G\Z/]

  def slug
    name.downcase.gsub(" ", "-")
  end
  def to_param
    "#{slug}-#{id}"
  end


  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
#  include Tire::Model::Search
#  include Tire::Model::Callbacks
  def self.parse_params(params)
    params 
  end
  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: parse_params(query),
            fields: ['name^2', 'j_ingreds', 's_tags']
          }
        }
      }
    )
    #tire.search(load: true) do
    #  query { string params[:search] } if params[:query].present?
    #end
  end
end
Recipe.__elasticsearch__.client.indices.delete index: Recipe.index_name rescue nil
#
Recipe.__elasticsearch__.client.indices.create index: Recipe.index_name,
  body: { settings: Recipe.settings.to_hash, mappings: Recipe.mappings.to_hash }

Recipe.import #to auto sync model with elastic search
