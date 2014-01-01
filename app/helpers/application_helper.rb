module ApplicationHelper

  def notification_objects_json
    notification_objects = []

    current_user.question_notifications.reverse_each do |notification|
      notification_objects.push({:url => notification_path(notification, :type => :q), :type => :q})
    end

    current_user.answer_notifications.reverse_each do |notification|
      notification_objects.push({:url => notification_path(notification, :type => :a), :type => :a})
    end

    return notification_objects.to_json.html_safe
  end

end
