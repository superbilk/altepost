json.array!(@calories) do |calory|
  json.extract! calory, :id, :calories, :dish_id
  json.url calory_url(calory, format: :json)
end
