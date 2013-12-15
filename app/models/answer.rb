class Answer
  include Mongoid::Document
  field :content, type: String
  #belongs_to :question
  embedded_in :question
end
