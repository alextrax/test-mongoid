class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])

    if @question.closed == true
    	redirect_to @question, :notice => "Answer closed!" 
    	return
    end

    if params[:answer][:content].gsub(/[ \t\r\n]/, '').length == 0
      respond_to do |format|
        format.json { render json: nil, status: :unprocessable_entity}
      end
      return
    end

    answer = @question.answers.create!(params[:answer])
    messages = []
    question_description = @question.content[0..30].gsub(/\s\w+\s*$/,'...')
    notification = @question.user.answer_notifications.create!(:question_url => question_path(@question), :question_description => question_description)
    notification_data = {:url => notification_path(notification, :type => :a), :type => :a, :question_description => question_description}
    messages.push({:channel => '/notifications/users/' + @question.user._id, :data => notification_data.to_json.html_safe})
    #message = {:channel => '/notifications/users/' + @question.user._id, :data => notification_data.to_json.html_safe}

    @question.followers.each do |follower|
      notification = follower.answer_notifications.create!(:question_url => question_path(@question), :question_description => question_description)
      notification_data = {:url => notification_path(notification, :type => :a), :type => :a, :question_description => question_description}
      messages.push({:channel => '/notifications/users/' + follower._id, :data => notification_data.to_json.html_safe})
    end


    faye_uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(faye_uri, :message => messages.to_json)

    respond_to do |format|
      format.json { render json: nil, status: :created}
    end
  end
end
