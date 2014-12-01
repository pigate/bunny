require 'elasticsearch/model'
class Recipe < ActiveRecord::Base
  belongs_to :author, :class_name => "Member"
  has_many :comments, :as => :commentable
  has_many :commenters, :through => :comments, :source => :commenter

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
            fields: ['name^10', 'text']
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
