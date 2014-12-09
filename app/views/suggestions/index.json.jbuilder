json.array!(@suggestions) do |suggestion|
  json.extract! suggestion, :id, :who_id, :description
  json.url suggestion_url(suggestion, format: :json)
end
