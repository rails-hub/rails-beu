class Deal < ActiveRecord::Base

  attr_accessible :description, :end_date, :image, :retailer_logo, :title, :font_name, :font_color, :font_size, :bold, :italic,
    :underline, :background_color, :back_image_or_color, :gift_or_seasonal_item, :file, :coupen_image, :retailer_image, :item_image,
    :background_image, :coupon_no, :redemption_code, :value, :image_url, :item_name, :store_id, :front_image_container_css,
    :description_css, :item_image_container_css, :consumed_count, :coupen_large_img, :is_inactive

  attr_accessor :file

  has_attached_file :background_image, :styles => { :thumb => "920x920>" }, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml"
  has_attached_file :coupen_image, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml"
  has_attached_file :coupen_large_img, :styles => {:original=> "900x900!"}, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml"
  has_attached_file :retailer_image, :styles => { :thumb => "100x100>" }, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml"
  has_attached_file :item_image, :styles => { :thumb => "100x100>" }, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml"

  #  has_attached_file :background_image, :styles => { :thumb => "920x920>" }
  #  has_attached_file :coupen_image
  #  has_attached_file :coupen_large_img, :styles => {:original=> "900x900!"}
  #  has_attached_file :retailer_image, :styles => { :thumb => "100x100>" }
  #  has_attached_file :item_image, :styles => { :thumb => "100x100>" }



  # relations
  belongs_to :store
  has_one :deals_wizard
  has_one :target_rule
  has_many :wallets
  #  has_many :users, :through => :wallets
  has_many :redeemed_deals
  has_many :generated_coupons
  has_many :users, :through => :redeemed_deals
  has_many :deals_view_users
  has_many :viewed_users, :source=>:user, :through=>:deals_view_users
  accepts_nested_attributes_for :viewed_users, :allow_destroy => true
  #scopes methods
  scope :get_deals_ids, select('id')
  scope :get_my_deals, lambda { |store_id,user_gender,get_rule_colum_name|
    joins("INNER JOIN target_rules  ON ( target_rules.all = true or (target_rules.#{user_gender} = true and
     target_rules.#{get_rule_colum_name} = true)) and deals.id=target_rules.deal_id").
      where(["target_rules.end_date >= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and target_rules.start_date <= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and (target_rules.gift_or_seasonal_item =false or target_rules.gift_or_seasonal_item IS NULL)"]).get_all_deals_with_store_id(store_id)
  }

  scope :get_non_redeemed_deals_with_rules, lambda { |user_gender,get_rule_colum_name|
    joins("INNER JOIN target_rules  ON ( target_rules.all = true or (target_rules.#{user_gender} = true and
     target_rules.#{get_rule_colum_name} = true)) and deals.id=target_rules.deal_id").
      where(["target_rules.end_date >= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and target_rules.start_date <= '#{Time.zone.now.utc.to_datetime.to_s(:db)}'"]).get_all_deals_without_store_id
  }
  scope :get_non_redeemed_deals_with_rules_without_gender, lambda { |get_rule_colum_name|
    joins("INNER JOIN target_rules  ON ( target_rules.all = true) and deals.id=target_rules.deal_id").
      where(["target_rules.end_date >= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and target_rules.start_date <= '#{Time.zone.now.utc.to_datetime.to_s(:db)}'"]).get_all_deals_without_store_id
  }

  # get all store deals by user id and store which are not redeemed.
  scope :get_non_redeemed_deals_with_rules_store_id_user_id, lambda { |user_id, store_id,user_gender,get_rule_colum_name|
    joins("INNER JOIN target_rules  ON ( target_rules.all = true or (target_rules.#{user_gender} = true and
     target_rules.#{get_rule_colum_name} = true)) and deals.id=target_rules.deal_id").
      where(["target_rules.end_date >= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and target_rules.start_date <= '#{Time.zone.now.utc.to_datetime.to_s(:db)}'"]).get_all_deals_with_store_id_user_id(user_id, store_id)
  }

  scope :get_current_my_deals, lambda { |store_id,user_gender,get_rule_colum_name|
    joins("INNER JOIN target_rules  ON ( target_rules.all = true or (target_rules.#{user_gender} = true and
     target_rules.#{get_rule_colum_name} = true)) and deals.id=target_rules.deal_id").where(["target_rules.end_date >= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and target_rules.start_date <= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and (target_rules.gift_or_seasonal_item =false or target_rules.gift_or_seasonal_item IS NULL)"]).get_current_all_deals_with_store_id(store_id)
  }
  scope :get_current_my_all_deals, lambda { |store_id,user_gender,get_rule_colum_name|
    joins("INNER JOIN target_rules  ON ( target_rules.all = true or (target_rules.#{user_gender} = true and
     target_rules.#{get_rule_colum_name} = true)) and deals.id=target_rules.deal_id").where(["target_rules.end_date >= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and target_rules.start_date <= '#{Time.zone.now.utc.to_datetime.to_s(:db)}'"]).get_current_all_deals_with_store_id(store_id)
  }
  scope :not_expire, joins(:target_rule).where("target_rules.end_date >= ?", Time.zone.now.utc.to_datetime.to_s(:db))
  scope :expire, joins(:target_rule).where("target_rules.end_date <= ?", Time.zone.now.utc.to_datetime.to_s(:db))


  scope :non_ended_deals_without_store_id, lambda {
    joins("INNER JOIN target_rules  ON  deals.id=target_rules.deal_id").where(["target_rules.end_date >= '#{Time.zone.now}' and target_rules.start_date <= '#{Time.zone.now}'"]).get_all_deals_without_store_id
  }

  scope :non_ended_deals_with_store_id, lambda { |store_id|
    joins("INNER JOIN target_rules  ON  deals.id=target_rules.deal_id").where(["target_rules.end_date >= '#{Time.zone.now}' and target_rules.start_date <= '#{Time.zone.now}'"]).get_all_deals_with_store_id(store_id)
  }

  scope :last_minute_non_redeemed_deals_with_rules ,
    lambda { |user_gender,get_rule_colum_name| joins("INNER JOIN target_rules  ON (target_rules.all = true or (target_rules.#{user_gender} = true
           and target_rules.#{get_rule_colum_name} = true ))  and deals.id=target_rules.deal_id").get_all_deals_without_store_id.
      where(["target_rules.start_date <= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and target_rules.end_date BETWEEN '#{Time.zone.now.utc.to_datetime.to_s(:db)}' AND '#{((Time.zone.now)+59.minutes).utc.to_datetime.to_s(:db)}'"])

  }

  scope :user_current_store, lambda { |u| where(:store_id => User.find(u).stores.first.id)  }
  scope :current_user_zone, lambda { |u|  }
  search_methods :user_current_store, :current_user_zone
  scope :get_all_deals_without_store_id, joins('LEFT OUTER JOIN redeemed_deals ON deals.id  = redeemed_deals.deal_id').where('redeemed_deals.id IS null')
  scope :get_all_deals_with_store_id, lambda {|store_id| joins('LEFT OUTER JOIN redeemed_deals ON deals.id  = redeemed_deals.deal_id').where('redeemed_deals.id IS null').where(:store_id=> store_id)}

  # get all deals by store ID and which are not redeemed.
  #  scope :get_all_deals_with_store_id_user_id, lambda {|user_id, store_id| joins('LEFT OUTER JOIN redeemed_deals ON deals.id  = redeemed_deals.deal_id').where('redeemed_deals.id <> null AND redeemed_deals.user_id = 76').where(:store_id=> store_id)}

  scope :get_current_all_deals_with_store_id, lambda {|store_id| joins('LEFT OUTER JOIN redeemed_deals ON deals.id  = redeemed_deals.deal_id').where(:store_id=> store_id)}

  scope :gift_and_seasonal_deals, lambda { |user_gender_condition,user_age_conditions|
    joins("INNER JOIN target_rules  ON (target_rules.gift_or_seasonal_item=true  and target_rules.end_date >= '#{Time.zone.now.utc.to_datetime.to_s(:db)}') and target_rules.start_date <= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and  deals.id=target_rules.deal_id").
      where(user_gender_condition).where(user_age_conditions).get_all_deals_without_store_id
  }
  scope :gift_and_seasonal_deals_all, lambda { |user_gender_condition,user_age_conditions|
    joins("INNER JOIN target_rules  ON (target_rules.gift_or_seasonal_item=true  and target_rules.end_date >= '#{Time.zone.now.utc.to_datetime.to_s(:db)}') and target_rules.start_date <= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and  deals.id=target_rules.deal_id").
      where(user_gender_condition).where(user_age_conditions)
  }

  scope :active, where(:is_inactive=>false)
  scope :inactive, where(:is_inactive=>true)


  def active_deal(user)
    if self.is_inactive == false and deals_search_rules(self.target_rule, user)
      return true
    else
      return false
    end
  end
  #  def self.inactive
  #    if self.is_inactive == false and deals_search_rules(self.target_rule, user)
  #      return true
  #    else
  #      return false
  #    end
  #  end


  def deals_search_rules(target_rule, user)
    #    if target_rule.end_date >= Time.zone.now and ((target_rule.male and user.gender == 'male') or(target_rule.female and user.gender == 'female')) and target_rule.attributes[target_rule.get_rule_colum_name(user.age.to_i)] and target_rule.attributes[:gift_or_seasonal]
    #    puts "ssssssssssssssssssssssssssss", target_rule.end_date >= Time.zone.now
    #    put
    if target_rule.end_date >= Time.zone.now 
      return true
    else
      return false
    end
  end
  def deals_search_rules_all(target_rule, user)
    #    if target_rule.end_date >= Time.zone.now and ((target_rule.male and user.gender == 'male') or(target_rule.female and user.gender == 'female')) and target_rule.attributes[target_rule.get_rule_colum_name(user.age.to_i)] and target_rule.attributes[:gift_or_seasonal]
    if self.is_inactive == false and target_rule.end_date >= Time.zone.now and ((target_rule.male and user.gender == 'male') or(target_rule.female and user.gender == 'female')) and target_rule.attributes[target_rule.get_rule_colum_name(user.age.to_i)]
      return true
    else
      return false
    end
  end



  #callbacks
  after_save do |deal|

  end

  after_create do |deal|
    if deal.coupon_no.blank?
      #generate 6 digits coupon code
      deal.update_attribute(:coupon_no, ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(6).join)
    end

  end


  #custom methods

  #images methods

  def coupen_img_url
    coupen_img = self.coupen_image.url(:original).split('?')[0]
    coupen_img.include?('missing') ? '' : coupen_img
  end

  def coupen_large_img_url
    coupen_img = self.coupen_large_img.url(:original).split('?')[0]
    coupen_img.include?('missing') ? '' : coupen_img
  end

  def self.get_all_deals_with_store_id_user_id(user_id_api, store_id,user_gender, get_rule_colum_name, user_id)
    @test =   Deal.active.joins("INNER JOIN target_rules  ON ( target_rules.all = true or (target_rules.#{user_gender} = true and
     target_rules.#{get_rule_colum_name} = true)) and deals.id=target_rules.deal_id").
      where(["target_rules.end_date >= '#{Time.zone.now.utc.to_datetime.to_s(:db)}' and target_rules.start_date <= '#{Time.zone.now.utc.to_datetime.to_s(:db)}'"]).get_all_deals_with_store_id_user_id(user_id, store_id)
  end

  def item_image_url
    item_img = self.item_image.url(:thumb).split('?')[0]
    item_img.include?('missing') ?  '' : item_img
  end

  def handle_images(session_id)

    temp_image = TempImage.find_by_session_id(session_id)

    if temp_image.present?
      images_hash = {}
      images_hash.merge!({:coupen_image => temp_image.final_image}) if temp_image.final_image.present?
      images_hash.merge!({:coupen_large_img => temp_image.final_large_img}) if temp_image.final_large_img.present?
      images_hash.merge!({:background_image => temp_image.logo_image}) if temp_image.logo_image.present?
      images_hash.merge!({ :retailer_image => temp_image.retail_image}) if temp_image.retail_image.present?
      images_hash.merge!({ :item_image => temp_image.thing_image}) if temp_image.thing_image.present?
      images_hash.merge!({ :description_css => temp_image.description_css}) if temp_image.description_css.present?
      images_hash.merge!({ :front_image_container_css => temp_image.front_image_container_css}) if temp_image.front_image_container_css.present?
      images_hash.merge!({ :item_image_container_css => temp_image.item_image_container_css}) if temp_image.item_image_container_css.present?

      temp_image.destroy if self.update_attributes(images_hash)

    end
  end

  def self.get_large_img_html(html)
    #    html="    <div id=\"dynamic_p\" style=\"overflow: hidden;position: relative;background-color:rgb(245, 245, 245);background: url('http://s3.amazonaws.com/beu-dev/deals/background_images/000/000/023/original/test1.png') no-repeat;background-size: 300px 300px!important;width:300px!important; height: 300px!important;max-width:300px!important; max-height: 300px!important;text-align: center;\"  >\n\n      \n\n          <div class=\"p_image\" id=\"img_container\" style=\"position: absolute;position: absolute; width: 60px; height: 71px; top: 223px; left: 211px;\">\n            <img src=\"http://s3.amazonaws.com/beu-dev/deals/retailer_images/000/000/023/original/dua.jpg\" width=\"100%\" height=\"100%\" alt=\"Preview\" />\n          </div>\n        <br/>\n        \n        <br/>\n\n        <span  id=\"text\" style=\"position: absolute;position: absolute; width: 89px; height: 29px; font-weight: bold; font-style: italic; text-decoration: underline; font-size: 10px; font-family: helvetica; color: rgb(255, 41, 184); left: 35px; top: 42px;font-weight: bold;font-style: italic;text-decoration: underline;font-size: 10px;font-family: helvetica;color: #ff29b8;\">\n\n          fffwwwwww333333333\n\n        </span>\n     \n    </div>\n\n    <script type=\"text/javascript\">\n\n      $(function(){\n     \n        $( \"#img_container, #item_img_container, #text\" ).resizable({ghost: true,\n          maxHeight: 200,\n          maxWidth: 240,\n          stop: function(){\n            save_style_data($(this));\n          }\n        });\n\n        $( \"#img_container, #item_img_container, #text\" ).draggable({ containment: \"#dynamic_p\", stop: function(){\n            save_style_data($(this));\n          }\n        });\n\n      });\n\n    </script>\n"

    #v=html.split(/(width:\s*\d*\px(!important)?\;)/)
    #    puts html.inspect
    puts "starting taks--------------------------------------------"
    html.gsub!("background-size: 300px 300px!important;", "background-size: 900px 900px!important;")
    html_arr=html.split(/((width|height|max-height|max-width|left|top|font-size):\s*\d*.?\d*px(!important)?\;)/)

    #v=html.split(/(width:\s*\d*px\;)/)
    #v=html.split(/((width|height):\s*\d*px(!important)?\;)/)
    html_arr.delete("width")
    html_arr.delete("max-width")
    html_arr.delete("height")
    html_arr.delete("max-height")
    html_arr.delete('!important')
    html_arr.delete('top')
    html_arr.delete('left')
    html_arr.delete('font-size')
    html_arr.delete(" ")
    html_arr.delete("")

    html_arr.each_with_index do |hv,i|
      if (hv.match('width:')!=nil and hv.match('max-width:')==nil)
        Deal.value_changer(hv,'width')

      elsif(hv.match('height:')!=nil and hv.match('max-height:')==nil)
        Deal.value_changer(hv,'height')

      elsif (hv.match('max-width:')!=nil)
        Deal.value_changer(hv,'max-width')

      elsif(hv.match('max-height:')!=nil)
        Deal.value_changer(hv,'max-height')

      elsif(hv.match('top:')!=nil and hv.match('stop:')==nil)
        Deal.value_changer(hv,'top')

      elsif(hv.match('left:')!=nil)
        Deal.value_changer(hv,'left')

      elsif(hv.match('font-size:')!=nil)
        Deal.value_changer(hv,'font-size')
      end
      html_arr.join(',')
    end

    html_string=""
    html_arr.each do |b|
      html_string=html_string+b
    end

    puts "ending taks--------------------------------------------"
    #    puts html_string.inspect
    return html_string
  end

  def self.value_changer(hv,attribute)

    val=hv.split(':')
    arr_val=val[1].split('px')
    replace_string = hv.match('!important').nil? ? "#{attribute}:#{arr_val[0].to_f*3}px;" : "#{attribute}:#{arr_val[0].to_f*3}px!important;"
    hv.gsub!(hv,replace_string)

  end






  def Deal.check_campaign_rules?(target_rule)

    target_rule.all == true or (target_rule.age_12_17==true and target_rule.age_18_35==true and target_rule.age_36_44==true and target_rule.age_45_and_older==true and target_rule.male==true and target_rule.female==true)
  end

  def campaigns_deduction(user_payment)

    consume_campaigns_no = Deal.check_campaign_rules?(self.target_rule) ? 2 : 1
    #[taimoor] if self.consumed_count==0 do deal update consumed count by consume_campaigns_no and also update userpayment
    #[taimoor] if self.consumed_count==1 do check consume_campaigns_no if it is 1 then do nothing if 2 then update consumed_count to 2 and +1 in user payment consume_compaign_no
    #[taimoor] if self.consumed_count==2 do nothing
    #[taimoor] the work belwo is according to logic stated above in comments

    case self.consumed_count
    when 0
      self.update_attribute(:consumed_count,consume_campaigns_no)
      self.dedut_campaign_no(user_payment,consume_campaigns_no)
    when 1
      case consume_campaigns_no
      when 2
        self.update_attribute(:consumed_count,consume_campaigns_no)
        self.dedut_campaign_no(user_payment,1)
      end
    end
  end

  def dedut_campaign_no(user_payment,consume_campaigns_no)
    user_payments_consumed_coupon_no = consume_campaigns_no + user_payment.consumed_campaigns
    user_payment.update_attribute(:consumed_campaigns , user_payments_consumed_coupon_no)
  end


  #static methods

  def self.get_my_coupons(store_id = 1, user, get_rule_colum_name)
    self.set_deals_data(user, Deal.get_my_deals(store_id,user.gender, get_rule_colum_name ))
  end

  def self.get_current_my_coupons(store_id = 1, user, get_rule_colum_name)
    self.set_deals_data(user, Deal.get_current_my_deals(store_id,user.gender, get_rule_colum_name ))
  end

  def self.get_current_my_all_coupons(store_id = 1, user, get_rule_colum_name)
    self.set_deals_data(user, Deal.get_current_my_all_deals(store_id,user.gender, get_rule_colum_name ))
  end

  def self.set_deals_data(user, coupens_list,birthday_deal=nil)
    coupens_hash = []

    logger.debug "***********\n\n\n\n\n\n 99999 #{coupens_list.inspect} ***"
    coupens_list.each do |coupen|
      unless coupen.blank?
        retailer_image_url = coupen.store.present? ? coupen.store.get_retailer_user_url : ''
        coupens_hash << coupen.attributes.merge!({:coupen_img_url => coupen.coupen_img_url,
            :coupen_large_img_url => coupen.coupen_large_img_url,
            :retailer_img_url => retailer_image_url,
            :item_img_url => coupen.item_image_url
          })
      end
    end
      return coupens_hash
  end

  def valid_deal?(coupen_attr, birthday_deal)
    if birthday_deal.present?

      if coupen_attr['within_30_days']=='t'
        return  (coupen_attr["end_date"] >= Time.zone.now and coupen_attr["end_date"] <= (Time.zone.now + 30.days)) ? true : false
      elsif coupen_attr['this_week']=='t'
        return  (coupen_attr["end_date"] >= Time.zone.now and coupen_attr["end_date"] <= (Time.zone.now + 7.days)) ? true : false
      elsif coupen_attr['today']=='t'
        return  coupen_attr["end_date"] >= (Time.zone.now) ? true : false
      end

    else
      return true
    end

  end




end
