class NotificationsController < ApplicationController
  def destroy
    type = params[:type]
    if type == "q"
      notification = current_user.question_notifications.find(params[:id])
    elsif type == "a"
      notification = current_user.answer_notifications.find(params[:id])
    end

    if notification
      question_url = notification.question_url
      notification.destroy
      redirect_to question_url
    else
      redirect_to root_url
    end
  end
end
