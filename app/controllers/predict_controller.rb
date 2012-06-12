require 'libsvm'

class PredictController < ApplicationController
  def init
    

    temp_file = Tempfile.new('model') 
    temp_file.puts request.body.read
     temp_file.close
    render :json => temp_file.path
  end

  def run
    documents = [[1, "Why did the chicken cross the road? Because a car was coming"],
                 [0, "You're an elevator tech? I bet that job has its ups and downs"]]

    dictionary = documents.map(&:last).map(&:split).flatten.uniq
    dictionary = dictionary.map { |x| x.gsub(/\?|,|\.|\-/,'') }
    
    model_file = params[:modelFile]
     model_file = session[:model] if model_file==nil
    model = Libsvm::Model.load model_file
    #"Why did the chicken cross the road? To get the worm"
    test_set = [1, params[:query]]
    test_document = test_set.last.split.map{ |x| x.gsub(/\?|,|\.|\-/,'') }

    doc_features = dictionary.map{|x| test_document.include?(x) ? 1 : 0 }
    pred = model.predict(Libsvm::Node.features(doc_features))
    render :json => "Predicted #{pred==1 ? 'funny' : 'not funny'}"
  end

end
