class PredictController < ApplicationController
  def init
    session[:model] = params[:model]
    @model_id = session[:model] 
    render :json => @model_id
  end

  def run
  end

end
