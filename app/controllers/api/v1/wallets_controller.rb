class Api::V1::WalletsController < Api::V1::BaseController

  before_filter :checkTokenKeyParam, :except => ["create", "new", "index", "show", "edit", "update"]
  before_filter :validateTokenKey, :except => ["create", "new", "index", "show", "edit", "update"]
  before_filter :getUserByTokenKey, :only => [:my_wallet, :redeem, :save_coupon ]
  before_filter :get_users_and_deals_ids , :only => [:edit, :new]
  # GET /wallets
  # GET /wallets.json
  def index
    @wallets = Wallet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wallets }
    end
  end

  #get user wallet by token_key
  def my_wallet
    user_age = getUserAgeByTokenKey
    #         get_rule_colum_name = TargetRule.get_rule_colum_name(user_age)
    #
    #         if get_rule_colum_name == false
    #         message = 'User Age is not specific to our requirements'
    #         else
    #           @wallets = Deal.joins(:wallets).where(['wallets.user_id=?',@user.id]).get_non_redeemed_deals_with_rules_without_gender(get_rule_colum_name).select('wallets.*, deals.*, target_rules.end_date as end_date')
    #           @wallets = Deal.set_deals_data(@user,@wallets)
    #
    #        end
    @wallets = @user.wallets.collect { |w| w.deal }
    @redemed_deals = @user.redeemed_deals
    @deals = []
    @redemed_deals.each do |r|
      @deals << r.deal
    end
    @wallets = @wallets - @deals
    @wallets = @wallets.reject{|w| w.is_inactive or w.target_rule.end_date <= Time.zone.now }
    #    @wallets = @wallets
    coupens_hash = []
    @wallets.each do |coupen|
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
    @wallets = coupens_hash if coupens_hash.present?
    respond_to do |format|
      if @wallets.blank?
        message = message.present? ? message : 'Wallet is empty'
        format.json {render json:{:success => false, :status_code => 400, :message => message }}
        format.xml {render xml:{:success => false, :status_code => 400, :message => message }}
        format.html {render json: {:success => false, :status_code => 400, :message => message }}
      else

        format.html {render json: {:success => true, :status_code => 200, :wallet => @wallets }}
        format.json {render json: {:success => true, :status_code => 200, :wallet => @wallet}}
        format.xml {render xml:{:success => true, :status_code => 200, :wallet => @wallet}}

      end
    end
  end

  # this function is no more usable
  #  def redeem
  #
  #    respond_to do |format|
  #
  #          format.html { render json: {:success => true, :status_code => 400, :message => "redeem coupon api changed and moved to redeemed_deals  "}}
  #          format.json { render json: {:success => true, :status_code => 400, :message => "redeem coupon api changed and moved to redeemed_deals"}}
  #          format.xml { render xml: {:success => true, :status_code => 400,   :message => "redeem coupon api changed and moved to redeemed_deals"}}
  #    end
  #    existing_wallet = @user.wallets.where(:deal_id => params[:deal_id])
  #    if existing_wallet.nil? || existing_wallet.count == 0
  #      wallet_params = {:redempt => true, :deal_id => params[:deal_id]}
  #      @wallet = @user.wallets.new(wallet_params)
  #
  #      respond_to do |format|
  #        if @wallet.save
  #          format.html { render json: {:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
  #          format.json { render json: {:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
  #          format.xml { render xml: {:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
  #        else
  #          format.html { render json: {:success => false, :status_code => 404, :message => "Error in redeeming coupon"}}
  #          format.json { render json: {:success => false, :status_code => 404, :message => "Error in redeeming coupon"}}
  #          format.xml { render xml: {:success => false, :status_code => 404, :message => "Error in redeeming coupon"}}
  #        end
  #      end
  #    else
  #      @wallet = existing_wallet.first
  #      respond_to do |format|
  #        if @wallet.update_attributes(:redempt => true)
  #          format.html { render json: {:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
  #          format.json { render json: {:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
  #          format.xml { render xml: {:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
  #        else
  #          format.html { render json: {:success => false, :status_code => 404, :message => "Error in redeeming coupon"}}
  #          format.json { render json: {:success => false, :status_code => 404, :message => "Error in redeeming coupon"}}
  #          format.xml { render xml: {:success => false, :status_code => 404, :message => "Error in redeeming coupon"}}
  #        end
  #      end
  #    end
  #  end


  # POST save coupon to my wallet
  def save_coupon
    if params[:deal_id].blank?
      message = 'Coupon id is not provided in parameters'
    else
      user_wallet_coupon = @user.wallets.where(:deal_id => params[:deal_id])
      if user_wallet_coupon.present?
        message = 'Coupon already in my Wallet'
      else
        wallet_params = { :deal_id => params[:deal_id]}
        @wallet = @user.wallets.new(wallet_params)

      end
    end
    
    respond_to do |format|
      if user_wallet_coupon.blank? and @wallet.present? and @wallet.save
        format.html { render json: {:success => true, :status_code => 200, :message => "You have saved the coupon successfully"}}
        format.json { render json: {:success => true, :status_code => 200, :message => "You have saved the coupon successfully"}}
        format.xml { render xml: {:success => true, :status_code => 200, :message => "You have saved the coupon successfully"}}
      else
        message = message.present? ? message : "Error in saving coupon"
        format.html { render json: {:success => false, :status_code => 400, :message => message }}
        format.json { render json: {:success => false, :status_code => 400, :message => message }}
        format.xml { render xml: {:success => false, :status_code => 400, :message => message }}
      end
    end
  end


  # GET /wallets/1
  # GET /wallets/1.json
  def show
    @wallet = Wallet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wallet }
    end
  end

  # GET /wallets/new
  # GET /wallets/new.json
  def new
    @wallet = Wallet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wallet }
    end
  end

  # GET /wallets/1/edit
  def edit
    @wallet = Wallet.find(params[:id])
  end

  # POST /wallets
  # POST /wallets.json
  def create
    @wallet = Wallet.new(params[:wallet])

    respond_to do |format|
      if @wallet.save
        format.html { redirect_to api_v1_wallet_path(@wallet), notice: 'Coupen was successfully created.' }
        format.json { render json: @wallet, status: :created, location: @wallet }
      else
        format.html { render action: "new" }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /wallets/1
  # PUT /wallets/1.json
  def update
    @wallet = Wallet.find(params[:id])

    respond_to do |format|
      if @wallet.update_attributes(params[:wallet])
        format.html { redirect_to api_v1_wallet_path(@wallet), notice: 'Wallet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wallets/1
  # DELETE /wallets/1.json
  def destroy
    @wallet = Wallet.find(params[:id])
    @wallet.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_wallets_path }
      format.json { head :no_content }
    end
  end

  def get_users_and_deals_ids
    @deal_ids = Deal.get_deals_ids
    @user_ids = User.get_users_ids
  end
end
