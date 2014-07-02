class ErrorsController < ApplicationController
  def routing
    respond_to do |format|
      format.html {
        render file: "#{Rails.root}/public/404.haml", status: 404, layout: 'devise' 
      }
      format.json {
        render json: {status: 404}
      }
    end
  end
end
