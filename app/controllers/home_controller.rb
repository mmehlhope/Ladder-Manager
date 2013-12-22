class HomeController < ApplicationController

  # GET /
  def index
    render "index", layout: false
  end

end
