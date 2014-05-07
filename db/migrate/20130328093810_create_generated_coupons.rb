class CreateGeneratedCoupons < ActiveRecord::Migration
  def change
    create_table :generated_coupons do |t|
      t.integer :user_id
      t.integer :deal_id
      t.string :coupons_code
      t.string :redempetion_code

      t.timestamps
    end
  end
end
