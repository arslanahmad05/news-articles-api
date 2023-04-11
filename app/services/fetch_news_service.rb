
class FetchNewsService

  def initialize(url=nil, params={})
    @api_key = ENV['NEWS_API_KEY']
    @url = url
    @params=params
  end

  def call
    begin
      request_url = "#{ENV['NEWS_API_URL']+@url}?q=#{@params[:q]}&from=#{@params[:date]}" if @params[:q].present? && @params[:date].present?
      request_url = "#{ENV['NEWS_API_URL']+@url}?country=#{@params[:country]}" if @params[:country].present?
      response = JSON.parse(RestClient.get("#{request_url}&apiKey=#{@api_key}"))
      response["articles"].each do |article|
        @topic = Topic.find_or_create_by(name: article["source"]["name"])
        @author = Author.find_or_create_by(name: article["author"])
        Article.create(topic_id: @topic&.id, title: article["title"],
                        description: article["description"], article_url: article["url"],
                        image_url: article["urlToImage"], published_at: article["publishedAt"],
                        content: article["content"], author_id: @author&.id )
      end
    rescue => e
      return e
    end

  end

end
