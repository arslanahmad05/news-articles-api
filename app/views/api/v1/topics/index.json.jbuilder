json.total_topics @topics&.count
json.topics @topics do |topic|
  json.id topic&.id
  json.name topic&.name
  json.total_articles topic&.articles.count
  json.created_at topic&.created_at
  json.updated_at topic&.updated_at
end
