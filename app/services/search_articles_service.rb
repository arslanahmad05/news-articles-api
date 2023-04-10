
class SearchArticlesService

  def initialize(url=nil, params={})
    @api_key = ENV['NEWS_API_KEY']
    @url = url
    @params=params
  end

  def call
    begin
      request_url = "#{ENV['NEWS_API_URL']+@url}?q=#{@params[:q]}"
      response = JSON.parse(RestClient.get("#{request_url}&apiKey=#{@api_key}"))
      return response
    rescue => e
      return e
    end

  end

end
