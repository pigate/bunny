class Group < ActiveRecord::Base
  belongs_to :owner, :class_name => "Group"
  has_many :group_memberships, foreign_key: "joined_group_id"
  has_many :members, :through => :group_memberships
  has_and_belongs_to_many :posts
  has_many :group_posts
  has_many :posts, through: :group_posts
  validates :name, :uniqueness => true

  def slug
    name.downcase.gsub(" ","-")
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
            fields: ['name^2','description']
          }
        }
      }
    )
  end

    
end


Group.__elasticsearch__.client.indices.delete index: Group.index_name rescue nil
#
Group.__elasticsearch__.client.indices.create index: Group.index_name,
  body: { settings: Group.settings.to_hash, mappings: Group.mappings.to_hash }

Group.import #to auto sync model with elastic search

