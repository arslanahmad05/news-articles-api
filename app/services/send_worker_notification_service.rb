class SendWorkerNotificationService

  def initialize()

  end

  def call
    @articles= Article.last(5)
    User.each do |user|
      UserMailer.send_worker_notication(user, @articles).deliver_now
    end
  end

end
