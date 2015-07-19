class Dish < ActiveRecord::Base

  validates :meal_id, :name, presence: true
  validates :meal_id, uniqueness: true

end
