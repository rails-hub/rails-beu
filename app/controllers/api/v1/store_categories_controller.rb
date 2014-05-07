class Api::V1::StoreCategoriesController < Api::V1::BaseController

  before_filter :checkTokenKeyParam, :only => ["stores"]
  before_filter :validateTokenKey, :only => ["stores"]
  before_filter :getUserByTokenKey, :only => ["stores"]

  # GET /store_categories
  # GET /store_categories.json
  def index
    @store_categories = StoreCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @store_categories }
    end
  end


  #get all the stores list by category_id by using rules.
  # Refactored and ehanced by taimoor
  def stores
   
    category_id = params[:category_id].present? ? params[:category_id] : []
    @stores = []
    if category_id.present?
            @stores =  Store.stores_data(params[:category_id])
            user_stores_ids = @user.user_stores.collect(&:store_id)
            
            stores = []
            @stores.each do |store|
              store_attr = store.attributes
              store_hash= {:retailer_img_url => store.get_retailer_user_url, :coupons_count => Deal.non_ended_deals_with_store_id(store.id).count}
              store_attr.merge!(store_hash)
              user_stores_ids.include?(store.id) ? store_attr.merge!('user_store' => true) : store_attr.merge!('user_store' => false)
              stores << store_attr
            end
            @stores = stores
    else
      message = 'Kindly Provide Valid Category Id(s)'
      status_code = 400
    end

    respond_to do |format|
      if @stores.blank?
        message = message.present? ? message : "No store found"
        status_code = status_code.present? ? status_code : 400
        format.json {render json:{:success => false, :status_code => status_code, :message => message}}
        format.xml {render xml:{:success => false, :status_code => status_code, :message => message}}
        format.html {render json:{:success => false, :status_code => status_code, :message => message}}
      else
        format.html {render json: {:success => true, :status_code => 200, :stores => @stores}}
        format.json {render json: {:success => true, :status_code => 200, :stores => @stores}}
        format.xml {render xml: {:success => true, :status_code => 200, :stores => @stores}}
      end
    end
  end

# previous function of get all stores by category id 
#  def stores_Asad
#    user = getUserByTokenKey
#    user_age = getUserAgeByTokenKey
#    user_gender = getUserGenderByTokenKey
#    category_id = params[:category_id].nil? ? 0 : params[:category_id]
#
#    if (user_age.nil? || user_gender.nil?) || (user_age == '' || user_gender == '')
#      @stores = StoreCategory.find_by_sql("select (select count(id) from user_stores where user_id = #{user.id} and store_id = b.id) as user_store, b.*
#      , (select count(id) from deals as e where e.store_id = b.id) as coupons_count
#      , a.category_id from store_categories as a inner join stores as b on a.store_id = b.id
#       where (#{category_id} = 0 OR a.category_id = #{category_id} ) order by b.name asc")
#    else
#      get_rule_colum_name = TargetRule.get_rule_colum_name(user_age)
#      if get_rule_colum_name== false
#        @stores = []
#      else
#            @stores = StoreCategory.find_by_sql("select (select count(id) from user_stores where user_id = #{user.id} and store_id = b.id) as user_store, b.*,
#       (select count(id) from deals as e where e.store_id = b.id) as coupons_count, a.category_id from store_categories
#       as a inner join stores as b on a.store_id = b.id inner join target_rules as c on b.target_rule_id = c.id
#      where (#{category_id} = 0 OR a.category_id = #{category_id} )
#      and (c.all = true or (c.#{user_gender} = true and c.#{get_rule_colum_name}=true)) order by b.name asc")
#      end
#
#    end
#
#
#
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

  # GET /store_categories/1
  # GET /store_categories/1.json
  def show
    @store_category = StoreCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @store_category }
    end
  end

  # GET /store_categories/new
  # GET /store_categories/new.json
  def new
    @store_category = StoreCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store_category }
    end
  end

  # GET /store_categories/1/edit
  def edit
    @store_category = StoreCategory.find(params[:id])
  end

  # POST /store_categories
  # POST /store_categories.json
  def create
    @store_category = StoreCategory.new(params[:store_category])

    respond_to do |format|
      if @store_category.save
        format.html { redirect_to api_v1_store_category_path(@store_category), notice: 'Store category was successfully created.' }
        format.json { render json: @store_category, status: :created, location: @store_category }
      else
        format.html { render action: "new" }
        format.json { render json: @store_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /store_categories/1
  # PUT /store_categories/1.json
  def update
    @store_category = StoreCategory.find(params[:id])

    respond_to do |format|
      if @store_category.update_attributes(params[:store_category])
        format.html { redirect_to api_v1_store_category_path(@store_category), notice: 'Store category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @store_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /store_categories/1
  # DELETE /store_categories/1.json
  def destroy
    @store_category = StoreCategory.find(params[:id])
    @store_category.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_store_categories_path }
      format.json { head :no_content }
    end
  end
end
