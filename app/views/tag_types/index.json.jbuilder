json.array! tag_types.each do |tag_type|
  json.name tag_type.name 
  json.id tag_type.id
end

