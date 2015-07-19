json.array!(@dishes) do |dish|
  json.extract! dish, :id, :meal_id, :food_type, :name, :date, :image_url
  json.url dish_url(dish, format: :json)
end
