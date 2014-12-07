require 'json'
module RecipesHelper
  def destringify(string_json)
    if (string_json != '' && string_json != nil)
#    if (string_json && /[A-Za-z]/.match(string_json))
      JSON.parse(string_json)
    else
      []
    end
  end
end
