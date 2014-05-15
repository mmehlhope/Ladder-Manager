class UsersController < ApplicationController
  require 'securerandom'

  before_action :authenticate_user!

  # GET /users
  # GET /users.json
  def index
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # debug
  end

end
