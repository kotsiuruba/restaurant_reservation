require 'rails_helper'

RSpec.describe Reservation, :type => :model do

  subject { described_class.new }

  it "is valid with valid attributes" do
    subject.table = Table.first
    subject.start_at = DateTime.parse "18.07.2016 12:00"
    subject.end_at = DateTime.parse "18.07.2016 14:00"
    expect(subject).to be_valid
  end

  # it "is not valid without table" do
  #   subject.start_at = DateTime.parse "18.07.2016 12:00"
  #   subject.end_at = DateTime.parse "18.07.2016 13:00"
  #   expect(subject).to_not be_valid
  # end

  it "is not valid without start_at" do
    subject.table = Table.first
    subject.end_at = DateTime.parse "18.07.2016 14:00"
    expect(subject).to_not be_valid
  end

  it "is not valid without end_at" do
    subject.table = Table.first
    subject.start_at = DateTime.parse "18.07.2016 12:00"
    expect(subject).to_not be_valid
  end

  it "is not valid with incorect date interval" do
    subject.table_id = Table.first.id
    subject.start_at = DateTime.parse "18.07.2016 12:00"
    subject.end_at = DateTime.parse "18.07.2016 11:00"
    expect(subject).to_not be_valid
  end

  it "is not valid when not matching restaurant time work" do
    subject.table = Table.first
    subject.start_at = DateTime.parse(subject.restaurant.open_at) - 1.minute
    subject.end_at = DateTime.parse(subject.restaurant.open_at) + 1.hour
    expect(subject).to_not be_valid
  end

  it "is not valid when overlaps another reservation" do
    subject.table = Table.first
    another_reservation = Reservation.where(:table_id => subject.table_id).first
    if !another_reservation.nil?
      subject.start_at = another_reservation.start_at
      subject.end_at = another_reservation.end_at
      expect(subject).to_not be_valid
    else
      true
    end
  end

end
