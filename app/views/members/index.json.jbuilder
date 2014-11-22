json.array!(@members) do |member|
  json.extract! member, :id, :first, :last, :user_name, :occupation
  json.url member_url(member, format: :json)
end
