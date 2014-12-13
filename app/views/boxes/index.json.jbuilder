json.array!(@boxes) do |box|
  json.extract! box, :id, :member_id
  json.url box_url(box, format: :json)
end
