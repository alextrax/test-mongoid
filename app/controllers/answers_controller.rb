class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])

    if @question.closed == true
    	redirect_to @question, :notice => "Answer closed!" 
    	return
    end

    answer = @question.answers.create!(params[:answer])
    @question.user.answer_notifications.create!(:question_url => question_url(@question))

    redirect_to @question, :notice => "Answer created!" 
  end
end
