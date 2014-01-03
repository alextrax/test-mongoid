class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])

    if @question.closed == true
    	redirect_to @question, :notice => "Answer closed!" 
    	return
    end

    answer = @question.answers.create!(params[:answer])
    messages = []
    notification = @question.user.answer_notifications.create!(:question_url => question_path(@question))
    notification_data = {:url => notification_path(notification, :type => :a), :type => :a}
    messages.push({:channel => '/notifications/users/' + @question.user._id, :data => notification_data.to_json.html_safe})
    #message = {:channel => '/notifications/users/' + @question.user._id, :data => notification_data.to_json.html_safe}

    @question.followers.each do |follower|
      notification = follower.answer_notifications.create!(:question_url => question_path(@question))
      notification_data = {:url => notification_path(notification, :type => :a), :type => :a}
      messages.push({:channel => '/notifications/users/' + follower._id, :data => notification_data.to_json.html_safe})
    end


    faye_uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(faye_uri, :message => messages.to_json)

    redirect_to root_url
  end
end
