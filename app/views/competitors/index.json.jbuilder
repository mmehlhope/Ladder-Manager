json.array!(@competitors) do |competitor|
  json.extract! competitor, :name
  json.url competitor_url(competitor, format: :json)
end
