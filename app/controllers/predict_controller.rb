require 'rb-libsvm'

class PredictController < ApplicationController
  def init
    session[:model] = request.body.read
   

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
    render :json => "model created..."
  end

  def run
  end

end
