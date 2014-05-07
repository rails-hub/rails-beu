class AddColumnIsActiveToAdminQuestions < ActiveRecord::Migration
  def change
    add_column :admin_questions, :is_active, :boolean
  end
end
