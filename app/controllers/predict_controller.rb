class PredictController < ApplicationController
  def init
    session[:model] = params[:model]
    @model_id = session[:model] 
    format.json render :partial => "predict/init.json"
  end

  def run
  end

end
