class Api::V1::UserStoresController < Api::V1::BaseController

  before_filter :checkTokenKeyParam, :except => ["create", "new", "index", "show", "edit", "update"]
  before_filter :validateTokenKey, :except => ["create", "new", "index", "show", "edit", "update"]
  before_filter :getUserByTokenKey, :only => [:stores, :saveUserStores]

  # GET /user_stores
  # GET /user_stores.json
  def index
    @user_stores = UserStore.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_stores }
    end
  end

  # GET /user_stores/1
  # GET /user_stores/1.json
  def show
    @user_store = UserStore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_store }
    end
  end


  #get User stores by token Key
  def stores
    @stores = []
    #get_user_by_token_key
    user_age = getUserAgeByTokenKey
    user_id_api = getUserByTokenKey
    get_rule_colum_name = TargetRule.get_rule_colum_name(user_age)
    if get_rule_colum_name == false
      message = 'User Age is not specific to our requirements'
    else
      
      user_stores = @user.stores.collect(&:id)
      Store.includes(:deals).order(:name).each do |store|
        hash ={}
        hash.merge!({:user_id => user_id_api.id})
        @redemed_deals = @user.redeemed_deals.select{|d| d.deal.store_id == store.id and d.deal.target_rule.gift_or_seasonal_item != true}
        @deals = []
        @redemed_deals.each do |r|
          @deals << r.deal
        end
        @store_deals_all = store.deals
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
        @coupons = @coupons.select { |cop| cop.target_rule.end_date >= Time.zone.now   }
        @coupons = @coupons.reject{|w| w.is_inactive}
        hash.merge!({:coupons_count => @coupons.count } )
        hash.merge!({:user_store => user_stores.include?(store.id)})
        hash.merge!({:retailer_img_url => store.get_retailer_user_url})
        @stores << store.attributes.merge!(hash)
      end
    end
   
    @stores = @stores.select{|store| store[:user_store] == true}
    if @user.age < 12
      @stores = {}
    end
    respond_to do |format|
      if @stores.present?
        format.html {render json: {:success => true, :status_code => 200, :stores => @stores}}
        format.json {render json: {:success => true, :status_code => 200, :stores => @stores}}
        format.xml {render xml: {:success => true, :status_code => 200, :stores => @stores}}
      else
        message = message.present? ? message : "User has no saved store"
        format.json {render json: {:success => false, :status_code => 400, :message => message}}
        format.html {render json: {:success => false, :status_code => 400, :message => message}}
        format.xml {render xml: {:success => false, :status_code => 400, :message => message}}
      end
    end
  end

  #post saveUserStores
  def saveUserStores
    store_ids = []
    store_ids = params[:store_ids].gsub(/[\A\[\]\z]/,'').split(',') if params[:store_ids]
    UserStore.delete_all("user_id = #{@user.id}")

    store_ids.each do |id|

      user_store = @user.user_stores.new(:store_id => id)
      if !user_store.save
        respond_to do |format|
          format.json {render json: {:success => false, :status_code => 400, :message => "error in saving user stores."}}
          format.html {render json: {:success => false, :status_code => 400, :message => "error in saving user stores."}}
          format.xml {render xml: {:success => false, :status_code => 400, :message => "error in saving user stores."}}
        end
        break
      end
    end


    respond_to do |format|
      status_code =  200
      success =  true
      message = "User stores saved successfully."
      format.json {render json: {:success => success, :status_code => status_code, :message => message}}
      format.html {render json: {:success => success, :status_code => status_code, :message => message}}
      format.xml {render xml: {:success => success, :status_code => status_code, :message => message}}
    end

  end


  # GET /user_stores/new
  # GET /user_stores/new.json
  def new
    @user_store = UserStore.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_store }
    end
  end

  # GET /user_stores/1/edit
  def edit
    @user_store = UserStore.find(params[:id])
  end

  # POST /user_stores
  # POST /user_stores.json
  def create
    @user_store = UserStore.new(params[:user_store])

    respond_to do |format|
      if @user_store.save
        format.html { redirect_to api_v1_user_store_path(@user_store), notice: 'User store was successfully created.' }
        format.json { render json: @user_store, status: :created, location: @user_store }
      else
        format.html { render action: "new" }
        format.json { render json: @user_store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_stores/1
  # PUT /user_stores/1.json
  def update
    @user_store = UserStore.find(params[:id])

    respond_to do |format|
      if @user_store.update_attributes(params[:user_store])
        format.html { redirect_to api_v1_user_store_path(@user_store), notice: 'User store was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_stores/1
  # DELETE /user_stores/1.json
  def destroy
    @user_store = UserStore.find(params[:id])
    @user_store.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_user_stores_url }
      format.json { head :no_content }
    end
  end
end
