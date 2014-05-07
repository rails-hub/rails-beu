class Api::V1::RedeemedDealsController < Api::V1::BaseController
  # GET /redeemed_deals
  # GET /redeemed_deals.json
  before_filter :checkTokenKeyParam#, :except => [:index]
  before_filter :validateTokenKey#, :except => [:index]
  before_filter :getUserByTokenKey

  def index
    @redeemed_deals = RedeemedDeal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @redeemed_deals }
    end
  end

  # GET /redeemed_deals/1
  # GET /redeemed_deals/1.json
  def show
    @redeemed_deal = RedeemedDeal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @redeemed_deal }
    end
  end

  # GET /redeemed_deals/new
  # GET /redeemed_deals/new.json
  def new
    @redeemed_deal = RedeemedDeal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @redeemed_deal }
    end
  end

  # GET /redeemed_deals/1/edit
  def edit
    @redeemed_deal = RedeemedDeal.find(params[:id])
  end

  # POST /redeemed_deals
  # POST /redeemed_deals.json
  def create
    
    @redeemed_deal = RedeemedDeal.new(params[:redeemed_deal])

    respond_to do |format|
        if @redeemed_deal.save
          format.html { render json: {:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
          format.json { render json: {:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
          format.xml { render xml: {:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
        else
          format.html { render json: {:success => false, :status_code => 400, :message => "Error in redeeming coupon"}}
          format.json { render json: {:success => false, :status_code => 400, :message => "Error in redeeming coupon"}}
          format.xml { render xml: {:success => false, :status_code => 400, :message => "Error in redeeming coupon"}}
        end
      end
  end
def params_available?
  if params[:deal_id].blank? or params[:redemption_code].blank? or params[:user_id].blank? or params[:coupon_code].blank?
    return false
  else
    return true
  end
end
def redemption_valid?(retailer, deal)
  
  if retailer.present? and deal.present?
     return retailer.stores.first.id == deal.store_id
  else
    return false
  end
  
end



def redeem
  
  case params_available?
  when false
    message = 'Required Parameters missing'
  else
    redemption_code = params[:redemption_code].upcase
    retailer = User.find_by_redemption_code(redemption_code)
    deal = Deal.find(params[:deal_id])
    if redemption_valid?(retailer, deal)
      redeemed_deal = RedeemedDeal.find_by_deal_id_and_user_id_and_redemption_code_and_coupon_code(params[:deal_id], params[:user_id],
      redemption_code, params[:coupon_code])
      if redeemed_deal.present?
        message = 'Coupon already redeemed'
      else
        params[:redeemed_deal] = {:deal_id => params[:deal_id], :user_id => params[:user_id], :redemption_code => redemption_code, :coupon_code => params[:coupon_code]}
        @redeemed_deal = RedeemedDeal.new(params[:redeemed_deal])
      end
    else
      message = 'Invalid Redemption Code'
    end
    
  end

  respond_to do |format|
    if params_available? and redeemed_deal.blank? and @redeemed_deal.present? and @redeemed_deal.save
      format.html { render json:{:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
      format.json { render json:{:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
      format.xml { render xml:{:success => true, :status_code => 200, :message => "You have redeemed the coupon successfully"}}
    else
      message = message.present? ? message : "Error in redeeming coupon"
      format.html { render json:{:success => false, :status_code => 400, :message => message}}
      format.json { render json:{:success => false, :status_code => 400, :message => message}}
      format.xml { render xml:{:success => false, :status_code => 400, :message => message}}
    end
  end
  
end


  # PUT /redeemed_deals/1
  # PUT /redeemed_deals/1.json
  def update
    @redeemed_deal = RedeemedDeal.find(params[:id])

    respond_to do |format|
      if @redeemed_deal.update_attributes(params[:redeemed_deal])
        format.html { redirect_to @redeemed_deal, notice: 'Redeemed deal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @redeemed_deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redeemed_deals/1
  # DELETE /redeemed_deals/1.json
  def destroy
    @redeemed_deal = RedeemedDeal.find(params[:id])
    @redeemed_deal.destroy

    respond_to do |format|
      format.html { redirect_to redeemed_deals_url }
      format.json { head :no_content }
    end
  end
end
