module RecipeSearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    mapping do

      indexes: :name, type: :string

      indexes: :ingreds do

      end

      indexes: :steps do

      end

      indexes: :created_at

      indexes: :author do
        indexes :first_name, type: :string, analyzer: :keyword
        indexes :last_name, type: :string, analyzer: :keyword
        indexes :user_name, type: :string, analyzer: :keyword 
      end

    end

    def self.search(query)

    end
  end
end
~                                                                               
~                  
