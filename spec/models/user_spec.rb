require 'swagger_helper'

RSpec.describe User, type: :model do
  subject { User.new(
      email: Faker::Internet.email,
      password: "123456",
      password_confirmation: "123456"
    ) }

  it "is not valid without a email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a password" do
    subject.password = nil
    expect(subject).to_not be_valid
  end
end
