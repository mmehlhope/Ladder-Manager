json.array!(@games) do |game|
  json.url game_url(game, format: :json)
end
