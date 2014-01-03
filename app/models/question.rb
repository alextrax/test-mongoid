class Question
  include Mongoid::Document
  field :title, type: String
  field :content, type: String
  field :closed, type: Boolean
  #has_many :answers
  embeds_many :answers
  belongs_to :user, inverse_of: :questions
  has_and_belongs_to_many :followers, class_name: "User", inverse_of: :following_questions
end
