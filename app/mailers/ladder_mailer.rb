class LadderMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  default from: "info@laddermanager.com"

  def invitation_email(user, password)
    @user     = user
    @password = password
    mail(to: @user.email, subject: "You are now an admin for #{@user.organization.name}!")
  end

  def welcome_email(user)
    @user = user
    @organization = @user.organization
    @url  = "http://laddermanager.com/organizations/#{@organization.id}"
    mail(to: @user.email, subject: "Welcome to LadderManager, #{@user.name}!")
  end


  # def new_ladder_email(user, ladder)
  #   @ladder = ladder
  #   @url  = "http://laddermanager.com/ladders/#{@ladder.id}"
  #   mail(from: "new-ladder@laddermanager.com", to: @ladder.user.email, subject: "Your new ladder: #{@ladder.name}")
  # end

  # def password_changed(ladder)
  #   @ladder = ladder
  #   @url  = "http://laddermanager.com/ladders/#{@ladder.id}"
  #   mail(to: @ladder.user.email, subject: "Password changed for #{current_user.name}")
  # end

  # def activation_email(ladder)
  #   @ladder = ladder
  #   @url  = "http://laddermanager.com/ladders/#{@ladder.id}"
  #   mail(to: @ladder.user.email, subject: "Password changed for #{current_user.name}")
  # end
end
