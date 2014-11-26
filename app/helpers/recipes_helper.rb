require 'json'
module RecipesHelper
  def destringify(string_json)
    if (string_json)
      JSON.parse(string_json)
    else
      []
    end
  end
end
