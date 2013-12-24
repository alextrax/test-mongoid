class Notification
  include Mongoid::Document
  field :question_url, type: String
  embedded_in :user
end
