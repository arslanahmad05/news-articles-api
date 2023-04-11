json.total_authors @authors&.count
json.authors @authors do |author|
  json.id author&.id
  json.name author&.name
  json.total_articles author.articles&.count
  json.created_at author&.created_at
  json.updated_at author&.updated_at
end
