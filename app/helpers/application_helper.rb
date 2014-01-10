module ApplicationHelper

  def notification_objects_json
    notification_objects = []

    current_user.question_notifications.each do |notification|
      notification_objects.push({:url => notification_path(notification, :type => :q), :type => :q, :question_description => notification.question_description})
    end

    current_user.answer_notifications.each do |notification|
      notification_objects.push({:url => notification_path(notification, :type => :a), :type => :a, :question_description => notification.question_description})
    end

    return notification_objects.to_json.html_safe
  end

  def channels_json
      channels = []
      channels.push("/notifications/users/" + current_user._id)

      return channels.to_json.html_safe
  end

end
