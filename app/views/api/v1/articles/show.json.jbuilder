
json.article do
  json.id @article&.id
  json.title @article&.title
  json.description @article&.description
  json.content @article&.content
  json.url @article&.article_url
  json.published_at @article&.published_at
  json.image_url @article&.image_url
  json.topic do
    json.id @article&.topic&.id
    json.name @article&.topic&.name
  end
  json.author do
    json.id @article&.author&.id
    json.name @article&.author&.name
  end
  json.created_at @article&.created_at
  json.updated_at @article&.updated_at
end
