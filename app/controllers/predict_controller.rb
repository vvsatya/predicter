class PredictController < ApplicationController
  def init
    session[:model] = params[:model]
    @model_id = session[:model] 
  end

  def run
  end

end
