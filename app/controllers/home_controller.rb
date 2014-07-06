class HomeController < ApplicationController

  # GET /
  def index
    @exclude_navigation = true
    render layout: "devise"
  end

end
