class Calory < ActiveRecord::Base
  belongs_to :dish

  validates :calories, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 1500,
                                       allow_blank: true
                                     } 
end
