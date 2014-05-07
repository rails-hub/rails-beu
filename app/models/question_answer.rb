class QuestionAnswer < ActiveRecord::Base
  attr_accessible :answer, :is_correct, :question_id
#  has_one :question
  belongs_to  :question
  
end
