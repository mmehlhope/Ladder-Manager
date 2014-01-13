class LadderMailer < ActionMailer::Base
  default from: "info@laddermanager.com"

  def welcome_email(ladder)
    @ladder = ladder
    @url  = "http://laddermanager.com/ladders/#{@ladder.id}"
    mail(from: "new-ladder@laddermanager.com", to: @ladder.user.email, subject: "Your new ladder: #{@ladder.name}")
  end

  def password_changed(ladder)
    @ladder = ladder
    @url  = "http://laddermanager.com/ladders/#{@ladder.id}"
    mail(to: @ladder.user.email, subject: "Password changed for #{current_user.name}")
  end
end
