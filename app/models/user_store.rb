class UserStore < ActiveRecord::Base
  attr_accessible :store_id, :user_id

  belongs_to :store ,:dependent => :destroy
  belongs_to :user


  def self.get_user_saved_stores(user,get_rule_colum_name)
    stores = []
    user.stores.includes(:deals).each do |store|
      store_attr = store.attributes
      @redemed_deals = @user.redeemed_deals.select{|d| d.deal.store_id == store.id}
      @deals = []
      @redemed_deals.each do |r|
        @deals << r.deal
      end
      coupon_count = (store.deals.count - @deals.count)
      #      coupon_count = store.deals.active.get_current_my_deals(store.id,user.gender, get_rule_colum_name ).keep_if { |d| Deal.find(d["id"]).users.include?(user).blank? }.count
      retailer_img_url = store.get_retailer_user_url
      stores << store_attr.merge!({:coupons_count => coupon_count, :retailer_img_url => retailer_img_url})
    end
    stores
  end
  #    # old query structure followed by asad to get user saved stores
  #    # @stores = UserStore.where(:user_id => @user.id).joins(:store).select("stores.*, (select count(id) from deals as e where e.store_id = user_stores.store_id) as coupons_count")

end
