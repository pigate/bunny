class Post < ActiveRecord::Base
  has_one :convo, :as => :conversable, :dependent => :destroy
  has_attached_file :photo,
    :default_url => "missing-recipe/:style.png",
    :styles => {
      :original => "590x405#",
      :cropped_square_thumb => {:geometry => "230x230#", :jcrop => true }
    },
    :convert_options => {
      :thumb => "-quality 75 -strip"
    },
    :bucket => ENV['AWS_BUCKET']
  belongs_to :author, :class_name => "Member"
  validates_attachment_content_type :photo, :content_type => /\Aimage/
  validates_attachment_file_name :photo, :matches => [/png\Z/, /PNG\Z/, /jpe?g\Z/, /JPE?G\Z/]
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
            fields: ['s_tags^2', 'post_text']
          }
        }
      }
    )
    #tire.search(load: true) do
    #  query { string params[:search] } if params[:query].present?
    #end
  end
end

Post.__elasticsearch__.client.indices.delete index: Post.index_name rescue nil
#
Post.__elasticsearch__.client.indices.create index: Post.index_name,
  body: { settings: Post.settings.to_hash, mappings: Post.mappings.to_hash }

Post.import #to auto sync model with elastic search


