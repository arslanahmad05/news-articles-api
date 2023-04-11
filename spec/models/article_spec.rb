require 'rails_helper'

RSpec.describe Article, type: :model do
  subject { Article.new(
      title: "remdom Topic",
      description: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph,
      article_url: "https://example.com",
      published_at: Date.today
    ) }

  it "is valid with valid attribute" do
    expect(subject).to be_valid
  end

  it "is not valid without a title" do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a description" do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a content" do
    subject.content = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a article_url" do
    subject.article_url = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a published_at" do
    subject.published_at = nil
    expect(subject).to_not be_valid
  end
end
