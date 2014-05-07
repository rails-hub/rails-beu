class UserPaymentsController < ApplicationController


  def new
    @user_payment = UserPayments.new
  end


  def change_subscription
    @user_payment = UserPayments.where(:user_id => current_user.id).last
    @self_plans = Plan.find_all_by_plan_type('s')
    @full_plans = Plan.find_all_by_plan_type('f')
    
    if @user_payment.blank?
      flash[:notice] = "No subscription found, Ask Admin to Purchase Subscription"
      redirect_to :back
    end

  end

# retailer subscription Base cases::
# Change subscription:
  # if subscription existing then two cases
    # 1.[done] if subcription not expired change subscription for remaining period
    # 2. [done] if subcription expired then show message "Renew Subscription to change Subscription"
  #[done] if subscription not exists
    # 1. [done] To be discused ))=> but my asumption is that there must be subscription when retailer created
    #  note: if not found subscription of retailer then ask him to ask admin to purchase subscription
# Renew subscription
  #[done] if user have no subscription show message to ask admin for making his subscription
  # [Note:above case will happen in case admin did not make payment on creation of user]
  #[done] if user subscription expired then add renew subscription from today
  #[done] if not expired then add new payments next to the end date of last payment

# Admin Subscription base cases::
  # Admin can make retailer new subscription on user creation
  def save_subscription_change
    
    @user_payments = UserPayments.where(["user_id=? and end_date>=?", current_user.id,Time.zone.now])
    @plan = Plan.find_by_id(params[:user_payments][:plan_id].to_i)
    
    if @user_payments.present?
#       flash[:notice] = "params[:user_payments][:plan_id]=#{params[:user_payments][:plan_id]}--- #{@plan.inspect}"
        response = UserPayments.get_change_subscription_amount(@plan, @user_payments)
        case response[0]
        when 'up_grade'
          if params[:payment_agreetopay]
             payment_response = make_payment(response[1])
             case payment_response[0]
             when true
                user_payments_updatation(response[0], @plan, @user_payments)
             else
               flash[:notice] = payment_response[1]
             end
          end
        when 'down_grade'
         # make_payment(response[1])
         # todo have to implement downgradaion
         flash[:notice] = "Your plan is downgraded and will be effective in next billing cycle"
        end
       
       redirect_to user_path(current_user.id)
      
    else
      flash[:notice] = "Renew Subscription to change Subscription"
      redirect_to :back
    end
    
    
  end

  def renew_subscription
    @user_payment = UserPayments.where(:user_id => current_user.id).last
    
    if @user_payment.blank?
      flash[:notice] = "No subscription found, Ask Admin to Purchase Subscription"
      redirect_to :back
    else
      @plan = Plan.find_by_id(@user_payment.plan_id)
    end
    
  end

  def save_renew_subscription
     @user_payments = UserPayments.where(:user_id => current_user.id)
     @plan = Plan.find_by_id(params[:plan_id].to_i)

    if @user_payments.present?
        if params[:payment_agreetopay]
          total_payment = params[:payment_amount]
          payment_response = make_payment(total_payment)
           case payment_response[0]
           when true
              user_payments_updatation('renew', @plan, @user_payments)
           else
             flash[:notice] = payment_response[1]
           end
        end
        
       redirect_to user_path(current_user.id)
    else
      flash[:notice] = "Renew Subscription to change Subscription"
      redirect_to :back
    end
  end

private
 

  def make_payment(amount)
    #flash[:notice]= "Error:Month #{Date.parse(params[:payment_expireDate]).strftime("%m")},Year: #{Date.parse(params[:payment_expireDate]).strftime("%Y")}"
    ActiveMerchant::Billing::Base.mode = :test
    gateway = ActiveMerchant::Billing::PaypalGateway.new(
        :login => "seller_1229899173_biz_api1.railscasts.com",
        :password => "FXWU58S7KXFC6HBE",
        :signature => "AGjv6SW.mTiKxtkm6L9DcSUCUgePAUDQ3L-kTdszkPG8mRfjaRZDYtSu"
    )
    credit_card = ActiveMerchant::Billing::CreditCard.new(
        :number             => params[:payment_cardNumber],
        :verification_value => "123",
        :month              => params[:expiry][:month],
        :year               => params[:expiry][:year],
        :first_name         => params[:payment_name],
        :last_name          => "xxx"
    )

    #testing code
    if true
      
      if true
        
        #actual code
#    if credit_card.valid?
#      response = gateway.authorize(amount, credit_card, purchase_options)
#      if response.success?
#        gateway.capture(amount, response.authorization)
      
       return true, ''

      else
        
        retrun false, "Error:response failed:: #{response.message}"
      end
    else
      retrun false, "Error: credit card is not valid. #{credit_card.errors.full_messages.join('. ')}"
    end
  end

  def user_payments_updatation(transaction_type, plan, user_payments)
    case transaction_type
    when 'up_grade'
      UserPayments.update_subscription(plan, user_payments)
    when 'down_grade'

    when 'renew'
      loop_count = params[:term].present? ? params[:term].to_i : 0
      user_payment_arr = UserPayments.renew_subscription(plan, user_payments, loop_count , current_user.id)
        case user_payment_arr.present?
        when true
          puts "user_payment_arr=#{user_payment_arr.inspect}---------------------------"
          UserPayments.create(user_payment_arr)
          flash[:notice]= 'Payment was successfully made and subscription renewed.'
        else
          flash[:error]= 'No Subscription plan selected'
        end
    end
  end

#    case user_payment_arr.present?
#    when true
#      puts "user_payment_arr=#{user_payment_arr.inspect} ---------------------------"
#      UserPayments.create(user_payment_arr)
#      flash[:notice]= 'Payment was successfully made.'
#    else
#      flash[:error]= 'No Subscription plan selected'
#    end

# def amount
#    (params[:payment_amount].to_i*100).to_i
# end
  
  

  def purchase_options
    {
        :ip => "127.0.0.1",
        :billing_address =>{
            :name => params[:payment_name],
            :address1 => params[:user_address],
            :city => "New York",
            :state => "NY",
            :country => "US",
            :zip => "1001"
        }
    }
  end


#  def save_user_payments
#
#    user_payment_arr = []
#        loop_count = params[:term].present? ? params[:term].to_i : 0
#        if loop_count>1
#          subsription_amount = (amount/loop_count)
#        end
#        plan = Plan.find_by_id(params[:user][:subscription_details_attributes]['0'][:plan_id])
#
#        user_payments = UserPayments.where(:user_id=>params[:id])
#        last_user_payment = user_payments.present? ? user_payments.last : ''
#        start_date = (last_user_payment.present? and last_user_payment.end_date >=Time.zone.now) ? last_user_payment.end_date + 1.days : Time.zone.now
#        end_date = start_date + 30.days
#        i = 0
#        until i== loop_count
#          i = i+1
#          allowed_campaigns = plan.compaigns_per_month.capitalize=='Unlimited' ? 100000 : plan.compaigns_per_month
#          user_payment_arr << {:start_date => start_date, :end_date => end_date, :month_number => i , :plan_id => plan.id,
#            :plan_type => plan.plan_type,:allowed_campaigns =>allowed_campaigns, :consumed_campaigns => 0, :user_id => @user.id,
#            :amount => subsription_amount, :status => 'success' }
#
#          start_date = end_date + 1.days
#          end_date = start_date + 30.days
#        end
#
#       return user_payment_arr
#  end


end
