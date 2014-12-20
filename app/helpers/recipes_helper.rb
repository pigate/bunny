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
  def round_float_2(some_float)
    some_float.round(2)
  end
  def get_rating_px(some_float)
    (some_float/5.0) * 69 #69 px
  end
end
