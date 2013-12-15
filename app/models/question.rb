class Question
  include Mongoid::Document
  field :title, type: String
  field :content, type: String
  field :closed, type: Boolean
  #has_many :answers
  embeds_many :answers
  belongs_to :user
  #has_and_belongs_to_many :answers , inverse_of: nil
end
