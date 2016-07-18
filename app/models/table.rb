class Table < ActiveRecord::Base

  belongs_to :restaurant
  has_many :reservations

  validates :number, :presence =>  true
  validates :number, uniqueness: { scope: :restaurant_id }

end
