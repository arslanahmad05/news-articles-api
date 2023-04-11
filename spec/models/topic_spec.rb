require 'rails_helper'

RSpec.describe Topic, type: :model do
  subject { Topic.new(
      name: Faker::Name.name,
    ) }

  it "is valid with valid attribute" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end
end
