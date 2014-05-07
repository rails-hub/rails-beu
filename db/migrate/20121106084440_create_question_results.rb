class CreateQuestionResults < ActiveRecord::Migration
  def change
    create_table :question_results do |t|
      t.string :question_answer
      t.integer :question_id
      t.integer :user_id

      t.timestamps
    end
  end
end
