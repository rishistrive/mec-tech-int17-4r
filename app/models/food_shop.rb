class FoodShop < ApplicationRecord
  
  validates :name, presence: true
  validates :code, presence: true

end
