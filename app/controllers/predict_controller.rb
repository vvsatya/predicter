class PredictController < ApplicationController
  def init
    session[:model] = request.body.read
   
    render :json => session[:model]
  end

  def run
  end

end
