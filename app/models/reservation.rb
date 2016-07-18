class Reservation < ActiveRecord::Base
  belongs_to :table
  has_one :restaurant, :through => :table

  validates_with ReservationIntervalValidator

end
