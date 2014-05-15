class HomeController < ApplicationController
  before_action :authenticate_user!

  # GET /
  def index
    @exclude_navigation = true
  end

end
