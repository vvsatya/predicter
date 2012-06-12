require 'libsvm'

class PredictController < ApplicationController
  def init
    
   

    documents = [[1, "Why did the chicken cross the road? Because a car was coming"],
                 [0, "You're an elevator tech? I bet that job has its ups and downs"]]

    dictionary = documents.map(&:last).map(&:split).flatten.uniq
    dictionary = dictionary.map { |x| x.gsub(/\?|,|\.|\-/,'') }

    training_set = []
    documents.each do |doc|
        features_array = dictionary.map { |x| doc.last.include?(x) ? 1 : 0 }
        training_set << [doc.first, Libsvm::Node.features(features_array)]
    end
    
    problem = Libsvm::Problem.new
    parameter = Libsvm::SvmParameter.new

    parameter.cache_size = 1 # in megabytes
    parameter.eps = 0.001
    parameter.c   = 10

    problem.set_examples(training_set.map(&:first), training_set.map(&:last))
    model = Libsvm::Model.train(problem, parameter)
    puts "\nModel.methods : "+ model.methods.sort.join("\n").to_s+"\n\n"
    
    temp_file = Tempfile.new('model') 
     temp_file.close
    model.save temp_file.path
   
    session[:model] = temp_file.path
    render :json => temp_file.path
  end

  def run
    model = session[:model]
    test_set = [1, "Why did the chicken cross the road? To get the worm"]
    test_document = test_set.last.split.map{ |x| x.gsub(/\?|,|\.|\-/,'') }

    doc_features = dictionary.map{|x| test_document.include?(x) ? 1 : 0 }
    pred = model.predict(Libsvm::Node.features(doc_features))
    render :json => "Predicted #{pred==1 ? 'funny' : 'not funny'}"
  end

end
