class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])

    if @question.closed == true
    	redirect_to @question, :notice => "Answer closed!" 
    	return
    end

    answer = @question.answers.create!(params[:answer])

    @question.reload

    if not(@question.answers.slice(0,5).include? answer)
    	answer.destroy
    	redirect_to @question, :notice => "Answer closed!" 
    	return
    end

    if @question.answers.count >= 5
    	@question.closed = true
    	@question.save
    end

    redirect_to @question, :notice => "Answer created!" 
  end
end
