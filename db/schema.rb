# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130328101051) do

  create_table "actions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "admin_classified_categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_category_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "admin_classifieds", :force => true do |t|
    t.text     "name"
    t.integer  "classified_category_id"
    t.boolean  "isactive"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "admin_hotspots", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "zone_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "admin_questions", :force => true do |t|
    t.string   "name"
    t.string   "ans1"
    t.string   "ans2"
    t.string   "ans3"
    t.string   "ans4"
    t.string   "ans5"
    t.string   "anscorrect"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "is_active"
  end

  create_table "admin_zones", :force => true do |t|
    t.string   "name"
    t.boolean  "isactive"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "campaigns", ["location_id"], :name => "index_campaigns_on_location_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "logo_url"
    t.integer  "target_rule_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "compaign_objectives", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contactus", :force => true do |t|
    t.string   "name"
    t.string   "company"
    t.string   "email"
    t.string   "phone"
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "credit_card_informations", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_number"
    t.string   "verification_code"
    t.datetime "expiry_date"
    t.integer  "user_id"
    t.string   "response"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "is_active",         :default => false
  end

  add_index "credit_card_informations", ["user_id"], :name => "index_credit_card_informations_on_user_id"

  create_table "deal_compaign_objectives", :force => true do |t|
    t.integer  "compaign_objective_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "deals_wizard_id"
  end

  create_table "deals", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "retailer_logo"
    t.string   "image"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "coupen_image_file_name"
    t.string   "coupen_image_content_type"
    t.integer  "coupen_image_file_size"
    t.datetime "coupen_image_updated_at"
    t.string   "retailer_image_file_name"
    t.string   "retailer_image_content_type"
    t.integer  "retailer_image_file_size"
    t.datetime "retailer_image_updated_at"
    t.string   "item_image_file_name"
    t.string   "item_image_content_type"
    t.integer  "item_image_file_size"
    t.datetime "item_image_updated_at"
    t.string   "font_name"
    t.string   "font_color"
    t.string   "font_size"
    t.boolean  "italic"
    t.boolean  "bold"
    t.boolean  "underline"
    t.string   "background_color"
    t.boolean  "back_image_or_color"
    t.string   "coupon_no"
    t.string   "redemption_code"
    t.string   "value"
    t.string   "image_url"
    t.string   "item_name"
    t.integer  "store_id"
    t.boolean  "gift_or_seasonal_item"
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.integer  "background_image_file_size"
    t.datetime "background_image_updated_at"
    t.text     "front_image_container_css"
    t.text     "description_css"
    t.text     "item_image_container_css"
    t.integer  "consumed_count",                :default => 0
    t.string   "coupen_large_img_file_name"
    t.string   "coupen_large_img_content_type"
    t.integer  "coupen_large_img_file_size"
    t.datetime "coupen_large_img_updated_at"
    t.boolean  "is_inactive",                   :default => false
  end

  create_table "deals_view_users", :force => true do |t|
    t.integer  "deal_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "deals_view_users", ["deal_id"], :name => "index_deals_view_users_on_deal_id"
  add_index "deals_view_users", ["user_id"], :name => "index_deals_view_users_on_user_id"

  create_table "deals_wizards", :force => true do |t|
    t.boolean  "fixed_offer"
    t.integer  "buy_units"
    t.float    "buy_offer"
    t.integer  "spend_amount"
    t.float    "spend_offer"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "buy"
    t.boolean  "spend"
    t.integer  "deal_id"
  end

  create_table "generated_coupons", :force => true do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.string   "coupons_code"
    t.string   "redempetion_code"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "plans", :force => true do |t|
    t.string   "title"
    t.float    "price"
    t.integer  "duration"
    t.datetime "expiry"
    t.string   "compaigns_per_month"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "plan_type"
  end

  create_table "question_answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "answer"
    t.boolean  "is_correct"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "question_results", :force => true do |t|
    t.string   "question_answer"
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "questions", :force => true do |t|
    t.string   "name"
    t.date     "expiry_date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "is_active"
  end

  create_table "redeemed_deals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "coupon_code"
    t.string   "redemption_code"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rules", :force => true do |t|
    t.string   "name"
    t.boolean  "all_age"
    t.integer  "age_from"
    t.integer  "age_to"
    t.string   "gender"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "store_categories", :force => true do |t|
    t.integer  "store_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "logo_url"
    t.integer  "target_rule_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "redemption_code"
  end

  create_table "subscription_details", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "expiry"
    t.float    "balance_due"
    t.string   "service_type"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "is_active",    :default => false
  end

  add_index "subscription_details", ["plan_id"], :name => "index_subscription_details_on_plan_id"
  add_index "subscription_details", ["user_id"], :name => "index_subscription_details_on_user_id"

  create_table "target_rules", :force => true do |t|
    t.string   "name"
    t.integer  "deal_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "age_12_17"
    t.boolean  "age_18_35"
    t.boolean  "age_36_44"
    t.boolean  "age_45_and_older"
    t.boolean  "male"
    t.boolean  "female"
    t.boolean  "today"
    t.boolean  "this_week"
    t.boolean  "within_30_days"
    t.boolean  "is_pastcustomer"
    t.boolean  "not_pastcustomer"
    t.boolean  "all"
    t.boolean  "gift_or_seasonal_item"
  end

  add_index "target_rules", ["deal_id"], :name => "index_target_rules_on_deal_id"

  create_table "temp_images", :force => true do |t|
    t.string   "logo_image_file_name"
    t.string   "logo_image_content_type"
    t.integer  "logo_image_file_size"
    t.datetime "logo_image_updated_at"
    t.string   "retail_image_file_name"
    t.string   "retail_image_content_type"
    t.integer  "retail_image_file_size"
    t.datetime "retail_image_updated_at"
    t.string   "thing_image_file_name"
    t.string   "thing_image_content_type"
    t.integer  "thing_image_file_size"
    t.datetime "thing_image_updated_at"
    t.string   "session_id"
    t.integer  "deal_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "final_image_file_name"
    t.string   "final_image_content_type"
    t.integer  "final_image_file_size"
    t.datetime "final_image_updated_at"
    t.text     "front_image_container_css"
    t.text     "description_css"
    t.text     "item_image_container_css"
    t.string   "local_final_image_file_name"
    t.string   "local_final_image_content_type"
    t.integer  "local_final_image_file_size"
    t.datetime "local_final_image_updated_at"
    t.string   "local_final_large_img_file_name"
    t.string   "local_final_large_img_content_type"
    t.integer  "local_final_large_img_file_size"
    t.datetime "local_final_large_img_updated_at"
    t.string   "final_large_img_file_name"
    t.string   "final_large_img_content_type"
    t.integer  "final_large_img_file_size"
    t.datetime "final_large_img_updated_at"
  end

  create_table "temp_users", :force => true do |t|
    t.string   "retailer_image_file_name"
    t.string   "retailer_image_content_type"
    t.integer  "retailer_image_file_size"
    t.datetime "retailer_image_updated_at"
    t.string   "session_id"
  end

  create_table "user_categories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user_payments", :force => true do |t|
    t.string   "status"
    t.float    "amount"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "month_number"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "allowed_campaigns"
    t.integer  "consumed_campaigns"
    t.integer  "plan_id"
    t.string   "plan_type"
  end

  create_table "user_stores", :force => true do |t|
    t.integer  "user_id"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_zones", :force => true do |t|
    t.integer  "user_id"
    t.integer  "zone_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "email",                         :default => "", :null => false
    t.string   "encrypted_password",            :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.string   "business_name"
    t.string   "administrator"
    t.string   "address"
    t.string   "mobile"
    t.datetime "dob"
    t.string   "gender"
    t.string   "udid"
    t.string   "device_type"
    t.string   "notification_key"
    t.string   "token_key"
    t.integer  "role_id"
    t.string   "redemption_code"
    t.string   "retailer_img_url_file_name"
    t.string   "retailer_img_url_content_type"
    t.integer  "retailer_img_url_file_size"
    t.datetime "retailer_img_url_updated_at"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "wallets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
