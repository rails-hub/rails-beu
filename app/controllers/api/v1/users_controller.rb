class Api::V1::UsersController < Api::V1::BaseController

before_filter :checkTokenKeyParam, :except => ["token_key","create", "new", "delete_profile", "index", "show", :destroy]
before_filter :validateTokenKey, :except => ["token_key", "create", "new", "delete_profile", "index", "show", :destroy]
before_filter :get_role_id, :set_user_password, :only => [:create, :update]
  # GET /users
  # GET /users.json
  def index
    getUserAgeByTokenKey
    @users = User.where(:role_id => Role::END_USER_ID).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  #GET user profile
  def profile
    @user = getUserByTokenKey
    if @user.nil?
      respond_to do |format|
        format.json {render json:{:success => false, :status_code => 404, :message => "User not found by token key provided"}}
        format.xml {render xml:{:success => false, :status_code => 404, :message => "User not found by token key provided"}}
        format.html {render json: {:success => false, :status_code => 404, :message => "User not found by token key provided"}}
      end
    else
      respond_to do |format|
        format.json {render json: {:success => true, :status_code => 200, :user_profile => @user}}
        format.html {render json: {:success => true, :status_code => 200, :user_profile => @user}}
      end
    end
  end


  #get delete user profile by udid
  def delete_profile
    udid = params[:udid]
    user = User.find_by_udid(udid)
    if user.nil?
      respond_to do |format|
        format.json {render json:{:success => false, :status_code => 404, :message => "User not found."}}
        format.xml {render xml:{:success => false, :status_code => 404, :message => "User not found."}}
        format.html {render json: {:success => false, :status_code => 404, :message => "User not found."}}
      end
    else
#      user.delete
      user.destroy
      respond_to do |format|
        format.json {render json:{:success => true, :status_code => 200, :message => "User profile deleted successfully."}}
        format.xml {render xml:{:success => true, :status_code => 200, :message => "User profile deleted successfully."}}
        format.html {render json: {:success => true, :status_code => 200, :message => "User profile deleted successfully."}}
      end
    end
  end

  # GET /users token key
  def token_key
    @user = User.find_by_udid(params[:udid])

    if !@user.nil?
      respond_to do |format|
        format.html { render json: {:success => "true", :status_code => 200, :token_key => @user.token_key, :user_id => @user.id} }# show.html.erb
        format.json { render json: {:success => "true", :status_code => 200, :token_key => @user.token_key, :user_id => @user.id} }
      end
    else
      respond_to do |format|
        format.html { render json: {:success => "false", :status_code => 404, :message => "User not found."} }# show.html.erb
        format.json { render json: {:success => "false", :status_code => 404, :message => "User not found."} }
      end
    end

  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    params[:user].merge!({:role_id => Role::END_USER_ID}) if params[:user].present?
    @user = User.new(params[:user])
    @user.token_key = Digest::MD5.hexdigest(params[:user][:udid])
    
    respond_to do |format|
      if @user.save
        format.html { render json: {:success => "true", :status_code => 200, :token_key => @user.token_key, :user_id => @user.id }}
        format.json { render json: {:success => "true", :status_code => 200, :token_key => @user.token_key, :user_id => @user.id }}
      else
        #format.html { render action: "new" }
        format.html { render json: {:success => "false", :message => @user.errors, :status_code => 404 }}
        format.json { render json: {:success => "false", :message => @user.errors, :status_code => 404 }}
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find_by_token_key(params[:token_key])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { render json: {:success => "true", :status_code => 200, :token_key => @user.token_key, :user_id => @user.id }}
        format.json { render json: {:success => "true", :status_code => 200, :token_key => @user.token_key, :user_id => @user.id }}
      else
        #format.html { render action: "new" }
        format.html { render json: {:success => "false", :message => @user.errors.map(&:inspect).join(', ') , :status_code => 400 }}
        format.json { render json: {:success => "false", :message => @user.errors.map(&:inspect).join(', ') , :status_code => 400 }}
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_users_path }
      format.json { head :no_content }
    end
  end

  def get_role_id
    params[:user].merge!(:role_id => Role::END_USER_ID ) if params[:user].present?
  end
  def set_user_password
    password = {:password => 'api_user', :password_confirmation => 'api_user'}
    params[:user].merge!(password) if params[:user].present?
  end
end
