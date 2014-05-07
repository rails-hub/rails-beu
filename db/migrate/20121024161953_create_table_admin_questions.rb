class CreateTableAdminQuestions < ActiveRecord::Migration
  def change
    create_table :admin_questions do |t|
      t.string :name
      t.string :ans1
      t.string :ans2
      t.string :ans3
      t.string :ans4
      t.string :ans5
      t.string :anscorrect

      t.timestamps
    end
  end

end
