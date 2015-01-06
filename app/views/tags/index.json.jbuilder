json.tags do
  json.array! tags.pluck :name
end

