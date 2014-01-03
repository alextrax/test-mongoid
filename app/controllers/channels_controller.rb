class ChannelsController < ApplicationController
  def index
    question_channels = []
    current_user.questions.each do |question|
      question_channels.push("/notifications/questions/" + question._id)
    end
    @channels = {:user => "/notifications/users/" + current_user._id}
  end
end
