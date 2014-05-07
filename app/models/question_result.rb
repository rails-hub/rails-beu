class QuestionResult < ActiveRecord::Base
  attr_accessible :question_answer, :question_id, :user_id
 
  belongs_to  :admin_question
  belongs_to   :user
end
