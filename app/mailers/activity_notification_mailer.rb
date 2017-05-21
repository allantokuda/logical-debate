class ActivityNotificationMailer < ApplicationMailer
  default from: "notifications@#{ENV['MAILGUN_DOMAIN'] || 'logical-debate-site'}"

  def notify_reply(new_message)
    @replying_message   = new_message
    @replying_user      = new_message&.user
    @replied_to_message = new_message&.subject
    @replied_to_user    = new_message&.subject&.user
    return unless @replied_to_user && @replied_to_user != @replying_user
    subject = "#{@replying_user.username} replied to you"
    mail(to: @replied_to_user.email, subject: subject)
  end
end
