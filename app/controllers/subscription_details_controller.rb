class SubscriptionDetailsController < ApplicationController

  before_filter :get_plans, :only => [:new, :edit]

  def index
    @subscription_details = SubscriptionDetails.all
  end

  def show
    @subscription_detail = SubscriptionDetails.find_by_id(params[:id])
  end

  def new
    @subscription_detail = SubscriptionDetail.new
    @url = subscription_details_path
  end

  def edit
    @subscription_detail = SubscriptionDetails.find_by_user_id(params[:id])
    @url = subscription_detail_path(@subscription_detail.id)
  end
  
  def update
    @subscription_detail = SubscriptionDetail.find_by_id(params[:id])
    respond_to do |format|
      if @subscription_detail.update_attributes(params[:subscription_details])
        format.html { redirect_to user_url(current_user.id) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription_detail.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def create
    @subscription_detail = SubscriptionDetail.new(params[:subscription_details])
    
      respond_to do |format|
        if @subscription_detail.save
        format.html {redirect_to user_url(current_user.id)}
        else
          format.html {render action: 'new'}
          format.json { render json: @subscription_detail.errors, status: :unprocessable_entity }
        end
      end
    
  end

#  def change_subscription_plan
#    @subscription_detail = SubscriptionDetails.new
#    @plan = Plan.all
#  end

  def renew_subscription
    @subscription_detail = SubscriptionDetails.find_by_id(params[:subscription_detail_id])
    @plan = @subscription_detail.plan
    @user = @subscription_detail.user
    
  end
  
  def save
    @subscription_detail = SubscriptionDetails.new(params[:subscription_detail])
  end

  def get_plans
    @plans = Plan.all
  end

end
