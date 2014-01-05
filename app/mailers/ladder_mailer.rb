class LadderMailer < ActionMailer::Base
  default from: "info@laddermanager.com"

  def welcome_email(ladder)
    @ladder = ladder
    @url  = "http://laddermanager.com/ladders/#{@ladder.id}"
    mail(from: "new-ladder@laddermanager.com", to: @ladder.admin_email, subject: "Your new ladder: #{@ladder.name}")
  end
end
