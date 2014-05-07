class Api::V1::UserCategoriesController < Api::V1::BaseController


  before_filter :checkTokenKeyParam, :except => ["create", "new", "index", "show", "edit", "update"]
  before_filter :validateTokenKey, :except => ["create", "new", "index", "show", "edit", "update"]
  before_filter :getUserByTokenKey, :only => [:saveUserCategories, :categories]

  # GET /user_categories
  # GET /user_categories.json
  def index
    @user_categories = UserCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_categories }
    end
  end

  # GET /user_categories/1
  # GET /user_categories/1.json
  def show
    @user_category = UserCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_category }
    end
  end


  #get User categories by token Key
  def categories
   
    @categories = UserCategory.joins(:category).where(:user_id => @user.id).select("categories.*")

    respond_to do |format|
      if @categories.blank?
        format.html {render json: {:success => true, :status_code => 200, :categories => @categories}}
        format.json {render json: {:success => true, :status_code => 200, :categories => @categories}}
        format.xml {render xml: {:success => true, :status_code => 200, :categories => @categories}}
      else
        format.json {render json: {:success => false, :status_code => 404, :message => "User has no saved category"}}
        format.html {render json: {:success => false, :status_code => 404, :message => "User has no saved category"}}
        format.xml {render xml: {:success => false, :status_code => 404, :message => "User has no saved category"}}
      end
    end
  end

  #post saveUserCategories
  def saveUserCategories
    category_ids = []
    category_ids = params[:category_ids].gsub(/[\A\[\]\z]/,'').split(',') if params[:category_ids]
    UserCategory.delete_all("user_id = #{@user.id}") 
    category_ids.each do |id|

      user_category = @user.user_categories.new(:category_id => id)
      if !user_category.save
        respond_to do |format|
          format.json {render json: {:success => false, :status_code => 400, :message => "error in saving user categories."}}
          format.html {render json: {:success => false, :status_code => 400, :message => "error in saving user categories."}}
          format.xml {render xml: {:success => false, :status_code => 400, :message => "error in saving user categories."}}
        end
        break
      end
    end


    respond_to do |format|
      status_code =  200
      success = true
      message = "User categories saved successfully."
      format.json {render json: {:success => success, :status_code => status_code, :message => message }}
      format.html {render json: {:success => success, :status_code => status_code, :message => message }}
      format.xml {render xml: {:success => success, :status_code => status_code, :message => message }}
    end


  end

  # GET /user_categories/new
  # GET /user_categories/new.json
  def new
    @user_category = UserCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_category }
    end
  end

  # GET /user_categories/1/edit
  def edit
    @user_category = UserCategory.find(params[:id])
  end

  # POST /user_categories
  # POST /user_categories.json
  def create
    @user_category = UserCategory.new(params[:user_category])

    respond_to do |format|
      if @user_category.save
        format.html { redirect_to api_v1_user_category_path(@user_category), notice: 'User category was successfully created.' }
        format.json { render json: @user_category, status: :created, location: @user_category }
      else
        format.html { render action: "new" }
        format.json { render json: @user_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_categories/1
  # PUT /user_categories/1.json
  def update
    @user_category = UserCategory.find(params[:id])

    respond_to do |format|
      if @user_category.update_attributes(params[:user_category])
        format.html { redirect_to api_v1_user_category_path(@user_category), notice: 'User category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_categories/1
  # DELETE /user_categories/1.json
  def destroy
    @user_category = UserCategory.find(params[:id])
    @user_category.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_user_categories_path }
      format.json { head :no_content }
    end
  end

end
