require 'json'

module PostsHelper
  def destringify_tags(string_json)
    begin
      if (string_json != '' && string_json != nil)
  #    if (string_json && /[A-Za-z]/.match(string_json))
        s_tags = JSON.parse(string_json)
        post_tags = s_tags["tags"]
      else
        []
      end
    rescue
      []
    end
  end

end
