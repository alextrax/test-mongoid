class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])

    if @question.closed == true
    	redirect_to @question, :notice => "Answer closed!" 
    	return
    end

    answer = @question.answers.create!(params[:answer])
    notification = @question.user.answer_notifications.create!(:question_url => question_path(@question))

    notification_data = {:url => notification_path(notification, :type => :a), :type => :a}
    message = {:channel => '/notifications/questions/' + @question._id, :data => notification_data.to_json.html_safe}
    faye_uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(faye_uri, :message => message.to_json)

    redirect_to @question, :notice => "Answer created!" 
  end
end
