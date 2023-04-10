json.total_articles @articles["totalResults"]
json.articles @articles["articles"] do |article|
  json.title article["title"]
  json.description article["description"]
  json.content article["content"]
  json.url article["url"]
  json.published_at article["published_at"]
  json.image_url article["urlToImage"]
  json.topic do
    json.id article["source"]["id"]
    json.name article["source"]["name"]
  end
end
