class ImportNewsImranKhan
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform()
    FetchNewsService.new("/everything", {q:"imran khan", date:Date.today-2.days}).call
    SendWorkerNotificationService.new().call
  end

end
