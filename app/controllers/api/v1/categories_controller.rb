class Api::V1::CategoriesController < Api::V1::BaseController


  before_filter :checkTokenKeyParam, :only => ["categories"]
  before_filter :validateTokenKey, :only => ["categories"]
  before_filter :get_rules_ids, :only => [:new, :edit]
  before_filter :getUserByTokenKey, :only => ["categories"]
  # GET /categories
  # GET /categories.json
  def index


    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  #get all the categories list by using rules.
  def categories
        # @categories = Category.get_categories(@user.id)
        #@categories =Category.all.select(:id).select(:name).select(:description).select(:logo_url)
         @categories =Category.all
         user_cat= @user.categories.collect(&:id)
         categories = []
         @categories.each do |cat|
          cat_attr = cat.attributes
          user_cat.include?(cat.id) ? cat_attr.merge!('user_category' => true) : cat_attr.merge!('user_category' => false)
          categories << cat_attr
         end
         @categories = categories

    respond_to do |format|
      if @categories.blank?
        format.json {render json:{:success => false, :status_code => 404, :message => "No category found"}}
        format.xml {render xml:{:success => false, :status_code => 404, :message => "No category found"}}
        format.html {render json: {:success => false, :status_code => 404, :message => "No category found"}}
      else
        format.html {render json: {:success => true, :status_code => 200, :categories => @categories}}
        format.json {render json: {:success => true, :status_code => 200, :categories => @categories}}
        format.xml {render xml: {:success => true, :status_code => 200, :categories => @categories}}
      end
    end
  end
  #get all the categories list by using rules.
#  def categories_Asad
#    user = getUserByTokenKey
#    user_age = getUserAgeByTokenKey
#    user_gender = getUserGenderByTokenKey
#
#    if (user_age.nil? || user_gender.nil?) || (user_age == '' || user_gender == '')
#      @categories = Category.all()
#    else
#       get_rule_colum_name = TargetRule.get_rule_colum_name(user_age)
#      if get_rule_colum_name== false
#        @categories = []
#      else
#         @categories = Category.find_by_sql("select a.*, (select count(id) from user_categories where user_id = #{user.id} and category_id = a.id) as user_category from categories as a
#      inner join target_rules as b on a.target_rule_id = b.id
#      where (b.all = true or (b.#{user_gender} = true and b.#{get_rule_colum_name}=true)) order by a.name asc#")
#      end
#
#    end
#
#    respond_to do |format|
#      if @categories.nil? || @categories.count() == 0
#        format.json {render json:{:success => false, :status_code => 404, :message => "No category found"}}
#        format.xml {render xml:{:success => false, :status_code => 404, :message => "No category found"}}
#        format.html {render json: {:success => false, :status_code => 404, :message => "No category found"}}
#      else
#        format.html {render json: {:success => true, :status_code => 200, :categories => @categories}}
#        format.json {render json: {:success => true, :status_code => 200, :categories => @categories}}
#        format.xml {render xml: {:success => true, :status_code => 200, :categories => @categories}}
#      end
#    end
#  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to api_v1_categories_path, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to api_v1_categories_path, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_categories_path }
      format.json { head :no_content }
    end
  end
  
  def get_rules_ids
    @rules_ids = TargetRule.get_rules_ids
  end

end
