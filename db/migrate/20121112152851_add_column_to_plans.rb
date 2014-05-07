class AddColumnToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :plan_type, :string
  end
end
