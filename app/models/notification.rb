class Notification
  include Mongoid::Document
  field :question_url, type: String
  field :question_description, type: String
  embedded_in :user
end
