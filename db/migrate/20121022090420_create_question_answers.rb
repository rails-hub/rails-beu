class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :question_answers do |t|
      t.integer :question_id
      t.string :answer
      t.boolean :is_correct

      t.timestamps
    end
  end
end
