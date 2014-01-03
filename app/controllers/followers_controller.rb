class FollowersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @question.followers.push(current_user)

    redirect_to root_url
  end
end
