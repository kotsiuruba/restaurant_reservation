class Restaurant < ActiveRecord::Base

  has_many :tables
  has_many :reservations, :through => :tables

  # open_at and close_at must be in HH:MM format
  validates :open_at, :close_at, :time => true
  validates :title, :presence =>  true

end
