class MainController < ApplicationController
  def index
  	@questions = Question.where(closed: false).ne(user: current_user).limit(9).to_a
  end
end
