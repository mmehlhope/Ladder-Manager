json.array!(@ladders) do |ladder|
  json.extract! ladder, :name
  json.url ladder_url(ladder, format: :json)
end
