class Api::V1::StoresController < Api::V1::BaseController

  before_filter :checkTokenKeyParam, :only => ["stores"]
  before_filter :validateTokenKey, :only => ["stores"]
  before_filter :get_rules_ids, :only => [:new, :edit]
  before_filter :getUserByTokenKey, :only => [:stores]
  # GET /stores
  # GET /stores.json
  def index
    @stores = Store.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stores }
    end
  end

  #get Stores list using user age rules.
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
        @redemed_deals = @user.redeemed_deals.select{|d| d.deal.store_id == store.id}
        @deals = []
        @redemed_deals.each do |r|
          @deals << r.deal
        end
        hash.merge!({:coupons_count => (store.deals.select { |st| st.target_rule.end_date >= Time.zone.now and st.is_inactive == false  } - @deals).count} )
        #        hash.merge!({:coupons_count => Deal.active.get_non_redeemed_deals_with_rules_store_id_user_id(user_id_api, store.id,@user.gender, get_rule_colum_name ).count})
        hash.merge!({:user_store => user_stores.include?(store.id)})
        hash.merge!({:retailer_img_url => store.get_retailer_user_url})
        @stores << store.attributes.merge!(hash)
      end
    end
    
    respond_to do |format|
      if @stores.present?
        format.html {render json:{:success => true, :status_code => 200, :stores => @stores}}
        format.json {render json:{:success => true, :status_code => 200, :stores => @stores}}
        format.xml {render xml:{:success => true, :status_code => 200, :stores => @stores}}
      else
        message = message.present? ? message : "No store found"
        format.json {render json: {:success => false, :status_code => 400, :message => message}}
        format.html {render json: {:success => false, :status_code => 400, :message => message}}
        format.xml {render xml: {:success => false, :status_code => 400, :message => message}}
      end
    end
  end
  #  def stores
  #
  #    user_age = getUserAgeByTokenKey
  #    user_gender = getUserGenderByTokenKey
  #
  #    if (user_age.nil? || user_gender.nil?) || (user_age == '' || user_gender == '')
  #      @stores = Store.all()
  #    else
  #      #      @stores = Store.find_by_sql("select a.*, (select count(id) from deals as e where e.store_id = a.id) as coupons_count from stores as a inner join rules as b on a.rule_id = b.id where (b.gender = '#{user_gender}' and (b.age_from <= #{user_age} and b.age_to >= #{user_age}) or b.all_age = true) order by a.name asc")
  #
  #      #      @stores = Store.find_by_sql("select s.*,
  #      #      (select count(id) from deals as d where d.store_id = s.id And d.id = (select deal_id from wallets as w where w.deal_id=d.id and w.redempt=false))
  #      #       as coupons_count from stores as s inner join rules as r on s.rule_id = r.id
  #      #      where (r.gender = '#{user_gender}' and (r.age_from <= #{user_age} and r.age_to >= #{user_age}) or r.all_age = true) order by s.name asc")
  #
  #      #      @stores = Store.find_by_sql("select s.*,
  #      #      (select count(id) from deals as d where d.store_id = s.id And d.id = (select deal_id from wallets as w where w.deal_id=d.id and w.redempt=false))
  #      #       as coupons_count from stores as s inner join target_rules as r on s.rule_id = r.id
  #      #      where (r.gender = #{user_gender} and (r.age_from <= #{user_age} and r.age_to >= #{user_age}) or r.all_age = true) order by s.name asc#")
  #
  #      get_rule_colum_name = TargetRule.get_rule_colum_name(user_age)
  #
  #      if get_rule_colum_name== false
  #        @stores = []
  #      else
  #        And d.id = (select deal_id from wallets as w where w.deal_id=d.id and w.redempt=false)
  #        @stores = Store.find_by_sql("select s.*,
  #      (select count(id) from deals as d where d.store_id = s.id )
  #       as coupons_count from stores as s inner join target_rules as r on s.target_rule_id = r.id
  #      where (r.all = true or (r.#{user_gender} = true and r.#{get_rule_colum_name}=true))

  #       order by s.name asc")

  #        where (r.all = true or (r.#{user_gender} = true and r.#{get_rule_colum_name}=true))
  #      end
      
  #    end

  #    respond_to do |format|
  #      if @stores.nil? || @stores.count() == 0
  #        format.json {render json:{:success => false, :status_code => 404, :message => "No store found"}}
  #        format.xml {render xml:{:success => false, :status_code => 404, :message => "No store found"}}
  #        format.html {render json: {:success => false, :status_code => 404, :message => "No store found"}}
  #      else
  #        format.html {render json: {:success => true, :status_code => 200, :stores => @stores}}
  #        format.json {render json: {:success => true, :status_code => 200, :stores => @stores}}
  #        format.xml {render xml: {:success => true, :status_code => 200, :stores => @stores}}
  #      end
  #    end
  #  end

  # GET /stores/1
  # GET /stores/1.json
  def show
    @store = Store.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @store }
    end
  end

  # GET /stores/new
  # GET /stores/new.json
  def new
    @store = Store.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store }
    end
  end

  # GET /stores/1/edit
  def edit
    @store = Store.find(params[:id])
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(params[:store])

    respond_to do |format|
      if @store.save
        format.html { redirect_to api_v1_store_path(@store.id), notice: 'Store was successfully created.' }
        format.json { render json: @store, status: :created, location: @store }
      else
        format.html { render action: "new" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stores/1
  # PUT /stores/1.json
  def update
    @store = Store.find(params[:id])

    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to api_v1_store_path(@store.id), notice: 'Store was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store = Store.find(params[:id])
    @store.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_stores_url }
      format.json { head :no_content }
    end
  end

  def get_rules_ids
    @rules_ids = TargetRule.get_rules_ids
  end

end
