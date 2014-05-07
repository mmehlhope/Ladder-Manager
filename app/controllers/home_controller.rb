class HomeController < ApplicationController

  # GET /
  def index
    @exclude_navigation = true
  end

end
