class CreateCompaignObjectives < ActiveRecord::Migration
  def change
    create_table :compaign_objectives do |t|
      t.string :name
      t.timestamps
    end
  end
end
