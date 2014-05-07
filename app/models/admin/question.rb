class Admin::Question < ActiveRecord::Base


   has_many :question_results


  attr_accessible :ans1, :ans2, :ans3, :ans4, :ans5, :anscorrect, :name, :is_active


  validates_presence_of :name, :message => "of Question can't be blank"
  validates_presence_of :ans1, :message => "at least is required"


end
