class Store < ActiveRecord::Base
 
  attr_accessible :description, :logo_url, :name, :target_rule_id
  has_many :deals, :dependent=>:destroy
  belongs_to :target_rule

  scope :get_stores_ids, select('id')
  scope :stores_data, lambda{|category_ids| where(['store_categories.category_id IN(?)',category_ids.split(',')]).joins(:store_categories).select('store_categories.*,stores.*').order(:name)}
   
  #  scope :stores_deals, select('*').deals.count
  has_many :user_stores
  has_many :users, :through => :user_stores
  
  has_many :store_categories
  has_many :categories, :through => :store_categories

  def get_non_reedemed_deals
    self.deals.joins('LEFT OUTER JOIN redeemed_deals ON redeemed_deals.deal_id = deals.id').where('redeemed_deals.id is null')
  end

  def get_retailer_user_url
    
    if self.users.store_retailer.present?
      store_retailer = self.users.store_retailer.first
      store_retailer.get_retailer_img_url
    else
      ''
    end
    
  end

  def self.get_all_store_deals(user)
    stores = []
    Store.includes(:deals).all.each do |store|
      store_attr = store.attributes
      #      coupon_count = store.deals.active.count
      @redemed_deals = user.redeemed_deals.select{|d| d.deal.store_id == store.id}
      @deals = []
      @redemed_deals.each do |r|
        @deals << r.deal
      end
      deals = store.deals.select{|deal| deal.target_rule.gift_or_seasonal_item == false}
      coupon_count = (deals.count - @deals.select{|deal| deal.target_rule.gift_or_seasonal_item == false}.count)
      retailer_img_url = store.get_retailer_user_url
      stores << store_attr.merge!({:coupons_count => coupon_count < 1 ?  0 : coupon_count, :retailer_img_url => retailer_img_url})
    end
    stores
  end

  def user_redeemed_deals(user)
    @redemed_deals = user.redeemed_deals.select{|d| d.deal.store_id == self.id}
    @deals = []
    @redemed_deals.each do |r|
      @deals << r.deal
    end
    return @deals
  end

end
