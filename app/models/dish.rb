class Dish < ActiveRecord::Base
  has_many :calories
  validates :meal_id, :name, presence: true
  validates :meal_id, uniqueness: true

end
