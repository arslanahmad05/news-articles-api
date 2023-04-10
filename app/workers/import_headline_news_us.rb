class ImportHeadlineNewsUs
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform()
    FetchNewsService.new("/top-headlines", {country:"us"}).call
    SendWorkerNotificationService.new().call
  end

end
