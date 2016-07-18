require 'rails_helper'

RSpec.describe Restaurant, :type => :model do

  subject {
    described_class.new(
      :title => "Some restaurant",
      :open_at => "10:00",
      :close_at => "20:00"
    )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without name" do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with invalid open_at" do
    subject.open_at = "10:000"
    expect(subject).to_not be_valid
  end

  it "is not valid with invalid close_at" do
    subject.close_at = nil
    expect(subject).to_not be_valid
  end

end
