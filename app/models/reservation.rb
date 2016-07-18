class Reservation < ActiveRecord::Base
  belongs_to :table
  has_one :restaurant, :through => :table

  validates :start_at, :end_at, :presence =>  true
  validates_with DateIntervalValidator, :unless => "start_at.nil? || end_at.nil?"

end
