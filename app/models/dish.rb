class Dish < ActiveRecord::Base
  has_many :calories

  accepts_nested_attributes_for :calories

  validates :meal_id, :name, presence: true
  validates :meal_id, uniqueness: true

end
