class LadderMailer < ActionMailer::Base
  default from: "info@laddermanager.com"

  def welcome_email(ladder)
    @ladder = ladder
    @url  = "http://laddermanager.com/ladders/#{@ladder.id}"
    mail(to: @ladder.admin_email, subject: "New ladder: #{@ladder.name}")
  end
end
