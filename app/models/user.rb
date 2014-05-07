class User < ActiveRecord::Base
  #Nested Form Code--Begins --By Fakhar Khan 30-10-2012
  #------Stores
  attr_accessible :user_stores_attributes
  has_many :user_stores, :dependent => :destroy
  #---------Zones
  attr_accessible :user_zones_attributes
  has_many :user_zones, :dependent => :destroy
  accepts_nested_attributes_for :user_zones #, :reject_if => lambda { |a| a[:zone_id].blank? }, :allow_destroy => true
  #---------Categories
  attr_accessible :user_categories_attributes
  has_many :user_categories, :dependent => :destroy
  accepts_nested_attributes_for :user_categories #, :reject_if => lambda { |a| a[:category_id].blank? }, :allow_destroy => true
  #---------Subscription Details
  attr_accessible  :subscription_details_attributes
  has_many :subscription_details, :dependent => :destroy
  accepts_nested_attributes_for :subscription_details #, :reject_if => lambda { |a| a[:plan_id].blank? }, :allow_destroy => true

  #---------Payment History
  attr_accessible :user_paymentss
  has_many :user_paymentss, :dependent => :destroy
  accepts_nested_attributes_for :user_paymentss #, :reject_if => lambda { |a| a[:plan_id].blank? }, :allow_destroy => true
  #
  #
  #----credit info
  attr_accessible :credit_card_information_attributes, :credit_card_informations_attributes
  has_many :credit_card_informations, :dependent=>:destroy
  has_many :generated_coupons, :dependent=>:destroy
  accepts_nested_attributes_for :credit_card_informations, :allow_destroy => true
  #Nested Form Code--Ends


  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login, :temp_udid, :temp_mail
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :business_name, :administrator, :mobile, :address
  attr_accessible :name, :login, :dob, :role_id, :retailer_img_url
  attr_accessible :gender, :udid, :device_type, :notification_key, :api_user, :temp_udid, :temp_mail, :redemption_code
  attr_accessible :subscription_detail
  has_attached_file :retailer_img_url, :styles => { :thumb => "100x100>" }, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml"
  #validates :password, :presence=> false
  #  has_many :subscription_details, :dependent => :destroy
  has_many :wallets
  #  has_many :deals, :through => :wallets
  belongs_to :role
  
  has_many :stores, :through => :user_stores
  has_many :categories, :through => :user_categories
  has_many :zones, :through => :user_zones, :class_name=>"Admin::Zone"
  has_many :redeemed_deals
  has_many :deals, :through => :redeemed_deals
  has_many :deals_view_users
  has_many :viewed_deals, :source => :deal, :through => :deals_view_users
  accepts_nested_attributes_for :viewed_deals, :allow_destroy=>true
  
  accepts_nested_attributes_for :stores
  scope :get_users_ids, select('id')
  scope :store_retailer, where(:role_id=>2)

  #  before_save do |u|
  #    self.temp_udid = u.udid
  #    self.temp_mail = u.email
  #  end

  

  #  #validations for api user
  with_options :if => Proc.new {|u| u.role_id==3 } do |api_user|
    api_user.validates :device_type,
      :inclusion => {:in => ["iphone","android","blackberry"], :message => "Device Type is invalid"}
    api_user.validates :udid, :uniqueness => true, :presence => true
    api_user.validates :email, :uniqueness => false,:allow_blank => true, :if => Proc.new {|u| u.email.blank? }
    #
    def email_required?
      false
    end
    #    api_user.validates :udid, :uniqueness => true, :presence => true, :unless => 'self.udid!=self.temp_udid'
    #    api_user.validates :email, :uniqueness => true, :unless => 'self.temp_mail = self.email'
  end

  ##validations for site user
  with_options :if => Proc.new {|u| u.role_id!=3 } do |site_user|
    site_user.validates :username, :uniqueness => true, :presence => true
    site_user.validates :business_name, :uniqueness => true, :presence => true
    
  end

  def retailer_img_dimensions
    
    if retailer_img_url.queued_for_write[:original].present?
      dimensions = Paperclip::Geometry.from_file(retailer_img_url.queued_for_write[:original].path)
      if dimensions.width < 400 and dimensions.height < 400
        errors.add(:retailer_img_url,'Image width or height must be at least 400px')
      end
    end

  end

  #  validate :retailer_img_dimensions, :unless => "errors.any?"


  #  with_options :if => Proc.new{|u| u.role_id==3} do |api_user|
  #    api_user.va
  #  end
  #
  ## callback methods

  after_create do |u|
    if u.role_id==2 and u.redemption_code.blank?
      u.update_attribute(:redemption_code, ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(6).join)
    end

  end
  ## callback methods ended
 
  ##devise gem method to change validations on db
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value ", { :value => login.downcase }]).first
      #       # where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def get_retailer_img_url
    retailer_img = self.retailer_img_url.url(:original).split('?')[0]
    retailer_img.include?('missing') ?   '' : retailer_img
  end

  
  def handle_retailer_image(session_id)

    temp_user = TempUser.find_by_session_id(session_id)

    if temp_user.present?
      images_hash = {}
      images_hash.merge!({ :retailer_img_url => temp_user.retailer_image}) if temp_user.retailer_image.present?

      temp_user.destroy if self.update_attributes(images_hash)

    end
  end
 
  def subscription_detail=(s)
    self.subscription_details << SubscriptionDetail.new(s)
  end
  def active_subscription_detail
    if self.try(:subscription_details).try(:count) > 1
      self.try(:subscription_details).where(:is_active=>true).try(:first)
    else
      self.try(:subscription_detials).try(:first).try(:update_attribute, :is_active, true) if !self.try(:subscription_details).try(:first).try(:is_active) && self.try(:user_paymentss).where("DATE(user_payments.start_date) <= ? AND DATE(user_payments.end_date) >= ?", DateTime.now.to_date, DateTime.now.to_date + 1.month).present?
      self.try(:subscription_details).try(:first)
    end
  end
  def active_subscription_type
    self.try(:active_subscription_detail).try(:service_type)
  end
  def active_plan
    self.try(:active_subscription_detail).try(:plan)
  end
  def active_plan_title 
    self.try(:active_plan).try(:title)
  end
  def active_plan_campaign
    self.try(:active_plan).try(:compaigns_per_month)
  end

  def age
    unless self.dob.blank?
      date = Date.today
      day_diff = date.day - self.dob.day
      month_diff = date.month - self.dob.month - (day_diff < 0 ? 1 : 0)
      return (date.year - self.dob.year - (month_diff < 0 ? 1 : 0)).to_i
    else
      return 0
    end
  end

  def days_to_next_bday
    d = Date.parse(self.dob.to_s)

    next_year = Date.today.year
    next_bday = "#{d.day}-#{d.month}-#{next_year}"

    return (Date.parse(next_bday) - Date.today).to_i
  end
  
  def active_user_payment
    self.try(:user_paymentss).where("DATE(user_payments.start_date) <= ? AND DATE(user_payments.end_date) >= ?", DateTime.now.to_date, DateTime.now.to_date + 1.month).try(:first)
  end
  def active_payment_amount
    self.try(:active_user_payment).try(:amount).try(:to_i)
  end
  def is_admin? 
    self.role_id == Role::ADMIN_USER_ID
  end
end
