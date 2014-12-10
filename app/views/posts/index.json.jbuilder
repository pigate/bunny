json.array!(@posts) do |post|
  json.extract! post, :id, :author_id, :feed_id, :post_text, :s_tags
  json.url post_url(post, format: :json)
end
