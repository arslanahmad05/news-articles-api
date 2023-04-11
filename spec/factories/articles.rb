FactoryBot.define do
  factory :article do
    title { "remdom Topic" }
    description { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    article_url { "https://example.com" }
    published_at { Date.today }
    topic { FactoryBot.create(:topic) }
    author { FactoryBot.create(:author) }
  end
end
