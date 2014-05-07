class Api::V1::DealsController < Api::V1::BaseController

  before_filter :checkTokenKeyParam, :except => [:create, :new, :index, :show, :edit, :update, :destroy]
  before_filter :validateTokenKey, :except => [:create, :new, :index, :show, :edit, :update, :destroy]
  before_filter :get_stores, :only => [:edit, :new]
  before_filter :getUserByTokenKey, :only => [:coupons, :my_coupons, :last_minute_deals, :gifts_or_seasonal_deals, :search1, :generate_coupons]
  # GET /deals
  # GET /deals.json
  def index
    @deals = Deal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @deals }
    end
  end

  def search
    @deals_all = []
    if params[:item_name].present?
      @deals_all =  Deal.where("title ilike ?", "%#{params[:item_name]}%")
    end
    if params[:retailer_name].present?
      @store =Store.where("name ilike ?", "%#{params[:retailer_name]}%").first
      if @store
        @deals_all =  (@store.deals + @deals_all)
      end
    end
    if params[:retailer_category].present?
      @category = Category.find_by_id(params[:retailer_category])
      if @category
        @stores_categories =  StoreCategory.find_all_by_category_id(@category.id)
        @stores = []
        @stores_categories.each{|s| @stores << Store.find(s.store_id)}
        @stores.each { |store| @deals_all << store.deals  }
      end
    end
    @deals_all = @deals_all.flatten.uniq
    if params[:item_name].blank? and params[:retailer_name].blank? and params[:retailer_category].blank? and @deals_all.size < 1
      @deals_all = Deal.all
    end
    user_id_api = getUserByTokenKey
    @redemed_deals = @user.redeemed_deals
    @deals = []
    @redemed_deals.each do |r|
      @deals << r.deal
    end
    @deals_all = @deals_all - @deals
    @deals_all = @deals_all.select{|deal| deal.active_deal(@user) }
    @deals_all = @deals_all.reject{|w| w.is_inactive}
    coupens_hash = []
    @deals_all.each do |coupen|
      deal = Deal.find(coupen.id) rescue nil
      unless deal.blank?
        retailer_image_url = deal.store.present? ? deal.store.get_retailer_user_url : ''
        coupens_hash << coupen.attributes.merge!({:coupen_img_url => deal.coupen_img_url,
            :coupen_large_img_url => deal.coupen_large_img_url,
            :retailer_img_url => retailer_image_url,
            :item_img_url => deal.item_image_url
          })
      end
    end
    @deals_all = coupens_hash if coupens_hash.present?
    respond_to do |format|
      if @deals_all.present?
        format.json {render json:{:success => true, :status_code => 200, :deals => @deals_all}}
        format.html {render json:{:success => true, :status_code => 200, :deals => @deals_all}}
        format.xml {render xml:{:success => true, :status_code => 200, :deals => @deals_all}}
      else
        format.json {render json:{:success => false, :status_code => 400, :message => "No coupon found"}}
        format.xml {render xml:{:success => false, :status_code => 400, :message => "No coupon found"}}
        format.html {render json: {:success => false, :status_code => 400, :message => "No coupon found"}}
      end
    end

  end

  #get saved stores related coupons by store_id, coupons fullfilling target_rules with users  will be shown
  def my_coupons

    @coupons = []
    user_age = getUserAgeByTokenKey
    get_rule_colum_name = TargetRule.get_rule_colum_name(user_age)

    if get_rule_colum_name == false
      message = 'User Age is not specific to our requirements'
    else
      @coupons = Deal.active.get_my_coupons(params[:store_id], @user, get_rule_colum_name)
    end

    respond_to do |format|
      if @coupons.blank?
        message = message.present? ? message : "No coupon found"
        format.json {render json:{:success => false, :status_code => 400, :message => message }}
        format.xml {render  xml:{:success => false, :status_code => 400, :message => message }}
        format.html {render json:{:success => false, :status_code => 400, :message => message }}
      else
        format.json {render json:{:success => true, :status_code => 200, :coupons => @coupons}}
        format.html {render json:{:success => true, :status_code => 200, :coupons => @coupons}}
        format.xml {render  xml:{:success => true, :status_code => 200, :coupons => @coupons}}
      end
    end
  end

  #get all/my the coupons by store_id
  def coupons
    
    @coupons = []
    @store = Store.find_by_id(params[:store_id])

    @redemed_deals = @user.redeemed_deals.select{|d| d.deal.store_id == @store.id}
    @deals = []
    @redemed_deals.each do |r|
      @deals << r.deal
    end
    @coupons = @store.deals - @deals
    @coupons_all = @store.deals - @deals
    if params[:my_deals].present?
      #      #      @coupons_after = @coupons.select { |cop| (cop.target_rule.gift_or_seasonal_item == nil or cop.target_rule.gift_or_seasonal_item == false) and (cop.target_rule.attributes[:today] == false and cop.target_rule.attributes[:within_30_days] == false and cop.target_rule.attributes[:this_week] == false) }
      ##      @coupons = @coupons - @coupons_after
      #      columns = []
      #      if @user.days_to_next_bday <= 1 and @user.days_to_next_bday >= 0
      #        columns << "today"
      #      end
      #      if @user.days_to_next_bday <=7 and @user.days_to_next_bday >= 0
      #        columns << "this_week"
      #      end
      #      if @user.days_to_next_bday <=30 and @user.days_to_next_bday >= 0
      #        columns << "within_30_days"
      #      end
      #      if @user.age >= 12 and @user.age <= 17
      #        age = "age_12_17"
      #      elsif @user.age >= 18 and @user.age <= 35
      #        age = "age_18_35"
      #      elsif @user.age >= 36 and @user.age <= 44
      #        age = "age_36_44"
      #      elsif @user.age >= 45
      #        age = "age_45_and_older"
      #        else
      #          age = ''
      #      end
      #      @coupons_after = @coupons.select { |cop| cop.target_rule.gift_or_seasonal_item != true }
      #      @new_coupons = []
      #      if columns.size > 0
      #        columns.each do |col|
      #          #        @new_coupons <<  @coupons_all.select { |cop| cop.target_rule.gift_or_seasonal_item== true and cop.target_rule.end_date >= Time.zone.now and cop.target_rule.attributes[col]}
      #          @new_coupons <<  @coupons_all.select {|cop| cop.target_rule.attributes[col] == true }
      #        end
      #        @coupons = (@coupons_after + @new_coupons.flatten).uniq
      #      else
      ##        @new_coupons <<  @coupons_all.select {|cop| cop.target_rule.attributes[:today] == false and cop.target_rule.attributes[:within_30_days] == false and cop.target_rule.attributes[:this_week] == false}
      #        @coupons = (@coupons_after.select {|cop| cop.target_rule.attributes['today'] == false and cop.target_rule.attributes['within_30_days'] == false and cop.target_rule.attributes['this_week'] == false}).uniq
      #      end
      #      #      @coupons = (@new_coupons.flatten).uniq
      ##      @coupons = @coupons.select{|cop| (@user.gender.blank? ? true : cop.target_rule.attributes[@user.gender] ) and (age.blank? ? true : cop.target_rule.attributes[age])}





      @redemed_deals = @user.redeemed_deals.select{|d| d.deal.store_id == @store.id and d.deal.target_rule.gift_or_seasonal_item != true}
      @deals = []
      @redemed_deals.each do |r|
        @deals << r.deal
      end
      @store_deals_all = @store.deals
      columns = []
      if @user.days_to_next_bday <= 1 and @user.days_to_next_bday >= 0
        columns << "today"
      end
      if @user.days_to_next_bday <=7 and @user.days_to_next_bday >= 0
        columns << "this_week"
      end
      if @user.days_to_next_bday <=30 and @user.days_to_next_bday >= 0
        columns << "within_30_days"
      end
      if @user.age >= 12 and @user.age <= 17
          age = "age_12_17"
        elsif @user.age > 17 and @user.age <= 35
          age = "age_18_35"
        elsif @user.age > 35 and @user.age <= 44
          age = "age_36_44"
        elsif @user.age > 44
          age = "age_45_and_older"
        else
          age = ''
        end
      @deals_bdy = []
      if columns.size > 0
        columns.each do |col|
          @deals_bdy <<  @store_deals_all.select{ |cop| cop.target_rule.end_date >= Time.zone.now and cop.target_rule.attributes[col] == true}
        end
      end
      @deals_gs_false_bday_false = @store_deals_all.select {|cop| cop.target_rule.attributes['today'] == false and cop.target_rule.attributes['within_30_days'] == false and cop.target_rule.attributes['this_week'] == false and cop.target_rule.gift_or_seasonal_item != true }
      @store_deals = ( (@deals_bdy.flatten + @deals_gs_false_bday_false.flatten) - @deals ).uniq
      @coupons = @store_deals.select{|cop| (@user.gender.blank? ? true : cop.target_rule.attributes[@user.gender] ) and (age.blank? ? true : cop.target_rule.attributes[age]) }
      
      #      puts "ssssssssssssssssssssssssssss", @coupons.inspect
      #      puts "ssssssssssssssssssssssssssss", @coupons.count
      #      @redemed_deals = @user.redeemed_deals.select{|d| d.deal.store_id == @store.id and d.deal.target_rule.gift_or_seasonal_item != true}
      #      @deals = []
      #      @redemed_deals.each do |r|
      #        @deals << r.deal
      #      end
      #      #        .select { |cop| cop.target_rule.gift_or_seasonal_item != true}
      #      @store_deals_all = @store.deals
      #      @coupons_after = @store_deals_all.select { |cop| cop.target_rule.gift_or_seasonal_item != true}
      #      columns = []
      #      if @user.days_to_next_bday <= 1 and @user.days_to_next_bday >= 0
      #        columns << "today"
      #      end
      #      if @user.days_to_next_bday <=7 and @user.days_to_next_bday >= 0
      #        columns << "this_week"
      #      end
      #      if @user.days_to_next_bday <=30 and @user.days_to_next_bday >= 0
      #        columns << "within_30_days"
      #      end
      #      if @user.age >= 12 and @user.age <= 17
      #        age = "age_12_17"
      #      elsif @user.age >= 18 and @user.age <= 35
      #        age = "age_18_35"
      #      elsif @user.age >= 36 and @user.age <= 44
      #        age = "age_36_44"
      #      elsif @user.age >= 45
      #        age = "age_45_and_older"
      #      else
      #        age = ''
      #      end
      #      @deals_bdy = []
      #      if columns.size > 0
      #        columns.each do |col|
      #          @deals_bdy <<  @store.deals.select{ |cop| (cop.target_rule.end_date >= Time.zone.now and cop.target_rule.attributes[col] == true) unless cop.target_rule.blank? }
      #        end
      #      else
      #        @store_deals = (@coupons_after.select {|cop| cop.target_rule.attributes['today'] == false and cop.target_rule.attributes['within_30_days'] == false and cop.target_rule.attributes['this_week'] == false}).uniq
      #      end
      #      puts "ssssssssssssssssssssssssssss", @store_deals.inspect
      #      puts "ssssssssssssssssssssssssssss", @store_deals.count
      #      @store_deals = (@store_deals_all.select { |st| st.target_rule.end_date >= Time.zone.now and st.target_rule.gift_or_seasonal_item != true   } - @deals)
      #      puts "ssssssssssssssssssssssssssss", @store_deals.inspect
      #      puts "ssssssssssssssssssssssssssss", @store_deals.count
      #
      #      @store_deals = ((@store_deals + @deals_bdy.flatten) - @deals ).uniq
      #      puts "ssssssssssssssssssssssssssss", @store_deals.inspect
      #      puts "ssssssssssssssssssssssssssss", @store_deals.count
      #      @coupons = @store_deals.select{|cop| (@user.gender.blank? ? true : cop.target_rule.attributes[@user.gender] ) and (age.blank? ? true : cop.target_rule.attributes[age]) }
      #
      #      puts "ssssssssssssssssssssssssssss", @coupons.inspect
      #      puts "ssssssssssssssssssssssssssss", @coupons.count





    end

    @coupons = @coupons.select { |cop| cop.target_rule.end_date >= Time.zone.now   }
    @coupons = @coupons.reject{|w| w.is_inactive}
    coupens_hash = []
    @coupons.each do |coupen|
      unless coupen.blank?
        retailer_image_url = coupen.store.present? ? coupen.store.get_retailer_user_url : ''
        coupens_hash << coupen.attributes.merge!({:coupen_img_url => coupen.coupen_img_url,
            :coupen_large_img_url => coupen.coupen_large_img_url,
            :retailer_img_url => retailer_image_url,
            :item_img_url => coupen.item_image_url
          })
      end
    end
    if @user.age < 12
      coupens_hash = {}
    end
    respond_to do |format|
      if coupens_hash.blank?
        message = message.present? ? message : "No coupon found"
        format.json {render json:{:success => false, :status_code => 400, :message => message }}
        format.xml {render  xml:{:success => false, :status_code => 400, :message => message }}
        format.html {render json:{:success => false, :status_code => 400, :message => message }}
      else
        format.json {render json:{:success => true, :status_code => 200, :coupons => coupens_hash}}
        format.html {render json:{:success => true, :status_code => 200, :coupons => coupens_hash}}
        format.xml {render xml:{:success => true, :status_code => 200, :coupons => coupens_hash}}
      end
    end
  end

  # GET /deals/1
  # GET /deals/1.json
  def show
    @deal = Deal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deal }
    end
  end

  # GET /deals/new
  # GET /deals/new.json
  def new
    @deal = Deal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @deal }
    end
  end

  # GET /deals/1/edit
  def edit
    @deal = Deal.find(params[:id])
  end

  # POST /deals
  # POST /deals.json
  def create
    @deal = Deal.new(params[:deal])

    respond_to do |format|
      if @deal.save
        format.html { redirect_to api_v1_deal_path(@deal), notice: 'Deal was successfully created.' }
        format.json { render json: @deal, status: :created, location: @deal }
      else
        format.html { render action: "new" }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /deals/1
  # PUT /deals/1.json
  def update
    @deal = Deal.find(params[:id])

    respond_to do |format|
      if @deal.update_attributes(params[:deal])
        format.html { redirect_to api_v1_deal_path(@deal), notice: 'Deal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deals/1
  # DELETE /deals/1.json
  def destroy
    @deal = Deal.find(params[:id])
    @deal.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_deals_url }
      format.json { head :no_content }
    end
  end

  def get_stores
    @stores_ids = Store.get_stores_ids
  end

  def last_minute_deals

    user_age = getUserAgeByTokenKey
    get_rule_colum_name = TargetRule.get_rule_colum_name(user_age)
    user_gender = @user.gender
    if get_rule_colum_name == false
      message = 'User Age is not specific to our requirements'
    else

      @deals = Deal.active.last_minute_non_redeemed_deals_with_rules(user_gender,get_rule_colum_name)
      @deals = Deal.set_deals_data(@user,@deals || [])
    end
    #    @deals = @deals.reject{|w| w.is_inactive}
    @deals = @deals.reject{|w| w[:is_inactive]}
    respond_to do |format|
      if @deals.present?
        format.html {render json: {:success => true, :status_code => 200, :deals => @deals}}
        format.json {render json: {:success => true, :status_code => 200, :deals => @deals}}
        format.xml {render xml: {:success => true, :status_code => 200, :deals => @deals}}
      else
        message = message.present? ? message : "No Deals found"
        format.json {render json:{:success => false, :status_code => 404, :message => message}}
        format.xml {render xml:{:success => false, :status_code => 404, :message => message}}
        format.html {render json: {:success => false, :status_code => 404, :message => message}}

      end
    end
  end

  def gifts_or_seasonal_deals

#    @user_store_deals = @user.stores.collect { |d| d.deals  }.flatten
    user_age_conditions = get_user_age
    user_gender_conditions = get_user_gender
    if user_age_conditions.blank? or user_gender_conditions.blank?
      message = 'Required parameter(s) are not provided'
      # for quick fix of un avaialble ages for birthday deals
      #          @deals = Deal.all
      #           @deals = Deal.set_deals_data(@deals)
    else
      @deals = Deal.active.gift_and_seasonal_deals_all(user_gender_conditions, user_age_conditions).select('  deals.*, target_rules.*, deals.id as id')
      @deals_f = []
      @redemed_deals = @user.redeemed_deals
      @redemed_deals.each do |r|
        @deals_f << r.deal
      end
      @deals = @deals - @deals_f
      @deals = if params[:birthday_deal].present?
        @deals = Deal.all.select{|deal| deal.target_rule.gift_or_seasonal_item == true}
        @deals = @deals.select {|cop| cop.target_rule.attributes['today'] == true or cop.target_rule.attributes['within_30_days'] == true and cop.target_rule.attributes['this_week'] == true}
        gender = params[:category_id] == '3' ? 'male' : 'female'
        @deals = @deals.select {|cop| cop.target_rule.attributes[gender] == true }
        @deals_f = []
        @redemed_deals = @user.redeemed_deals
        @redemed_deals.each do |r|
          @deals_f << r.deal
        end
        @deals = @deals - @deals_f
        Deal.set_deals_data(@user,@deals, params[:birthday_deal])
      else
        @deals = @deals.reject { |deal| (deal.target_rule.this_week == true or deal.target_rule.within_30_days == true or deal.target_rule.today == true) and (deal.target_rule.gift_or_seasonal_item == true)  }
        Deal.set_deals_data(@user,@deals)
      end
      #      puts "sssssssssssssssssssssssss", Deal.set_deals_data(@user,@deals, params[:birthday_deal])
      #      puts "ppppppppppppppppppppppppppppp", Deal.set_deals_data(@user,@deals, params[:birthday_deal]).count
      #      put
    end
    @deals = @deals.reject{|w| w[:is_inactive]}
    @deals = @deals.select{|w| @user.stores.collect{|s| s.id}.include?(Deal.find(w['id']).store.id)}
    respond_to do |format|
      if @deals.present?
        format.html {render json: {:success => true, :status_code => 200, :deals => @deals}}
        format.json {render json: {:success => true, :status_code => 200, :deals => @deals}}
        format.xml {render xml: {:success => true, :status_code => 200, :deals => @deals}}
      else
        message = message.present? ? message : "No Deals found"
        format.json {render json:{:success => false, :status_code => 400, :message => message }}
        format.xml  {render xml:{:success => false,   :status_code => 400, :message => message }}
        format.html {render json:{:success => false, :status_code => 400, :message => message }}
      end
    end
  end

  #1=For Mom, 2=For Dad, 3=Birthday for Male, 4=Birthday for Female, 5=Girls Gift, 6=Boys Gift
  def get_user_gender
    user_gender = []
    case (params[:category_id].to_s)
    when '1', '5','4'
      #for  female
      user_gender = ["target_rules.female=?",true]
    when '2', '6','3'
      #for male
      user_gender = ["target_rules.male=?",true]
    end
    return user_gender
  end

  def get_user_age
    user_age = []
    case (params[:category_id].to_s)
    when '1', '2','3','4'
      #for  age above 12-17
      user_age = ['target_rules.age_18_35=? or target_rules.age_36_44=? or target_rules.age_45_and_older=?',true,true,true]
    when '5', '6'
      #for age = 12-17
      user_age = ['target_rules.age_12_17=?',true]
    end
    return user_age
  end

  def generate_coupons
    @generated_coupon = GeneratedCoupon.find_by_user_id_and_deal_id(@user.id, params[:deal_id])
    if @generated_coupon.blank?
      GeneratedCoupon.create(:user_id => @user.id, :deal_id => params[:deal_id], :coupons_code => (0...8).collect { |n| []  << (65 + rand(25)).chr }.join(), :redempetion_code => (0...8).collect { |n| []  << (65 + rand(25)).chr }.join())
    end
    @deals_view_users = DealsViewUser.find_by_user_id_and_deal_id(@user.id, params[:deal_id])
    if @deals_view_users.blank?
      DealsViewUser.create(:user_id => @user.id, :deal_id => params[:deal_id])
    end
    render :nothing => true
  end


end
