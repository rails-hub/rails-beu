class Question < ActiveRecord::Base
   attr_accessible :name, :is_active, :expiry_date
   has_many :question_answers
   has_many :question_results
end
