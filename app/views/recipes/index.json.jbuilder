json.array!(@recipes) do |recipe|
  json.extract! recipe, :id, :name, :about, :ingreds, :steps, :author_id
  json.url recipe_url(recipe, format: :json)
end
