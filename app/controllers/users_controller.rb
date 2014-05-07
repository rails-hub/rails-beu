class UsersController < Devise::RegistrationsController
  
  include SharedUser
  
  skip_before_filter :require_no_authentication
  before_filter :authenticate_user!
  before_filter :get_tmp_user
  
  
  def index
    @users = User.where(:role_id => Role::SITE_USER_ID)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
  
  def show
    @user = User.find(params[:id])
    @credit_card_information = CreditCardInformation.find_by_user_id(@user.id)
    
    @user_payments = @user.user_paymentss.where(['end_date >=?',Time.zone.now]).order(:id)
#   
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def new
    
    @user = User.new
    @user.user_stores.build
    @user.user_zones.build
    @user.user_categories.build
    @user.subscription_details.build

    
  end

 

  def create
    @user = User.new(params[:user])

    #Extra Fields
    @user.administrator =@user.username
    @user.name=@user.username
    #@user.password='123456'
    @user.password=([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(6).join
    @user.role_id=Role::SITE_USER_ID

      
    respond_to do |format|
      if @user.save
          @user.handle_retailer_image(session[:session_id])
          credit_information
         if @credit_info.save
         puts "@credit_info-------------------#{@credit_info.inspect}"
          #Create Store
          @store=Store.new({name: @user.business_name,description: @user.address})
          if @store.save
            #Assign Store
            @user_store=UserStore.new({user_id: @user.id,store_id: @store.id})#this line may be removed for the retailer
            if @user_store.save
              @store_category=StoreCategory.new({store_id:@store.id,category_id:UserCategory.find_by_user_id(@user.id).category_id })
              if @store_category.save
                UserMailer.registration_confirmation(@user).deliver
                format.html { redirect_to users_path }
                 if params[:payment_agreetopay]
                   make_payment(@user, @credit_info)
                 else
                   flash[:notice] = 'Retailer was successfully created'
                 end
              else
                flash[:error] = 'Error Assigning Category to Store'
                format.html { render action: "new" }
              end
            else
              flash[:error] = 'Error Assigning Store to Retailor [this method may be removed]'
              format.html { render action: "new" }
            end
          else
            flash[:error] = 'Error Saving Store'
            format.html { render action: "new" }
          end
      else
        flash[:error] = 'Error Saving Credit Information'
        format.html { render action: "new" }
      end
      else
        flash[:error] = 'Error Saving Retailer'
        format.html { render action: "new" }
      end
    end
  end


  def edit
    @user = User.find(params[:id])
    @credit_card_information = CreditCardInformation.find_by_user_id(@user.id)
    
    @user_payment = UserPayments.where(['user_id=? and end_date>=?',params[:id], Time.zone.now]).last

  end

  def update
    @user = User.find(params[:id])
    if current_user.role_id==Role::ADMIN_USER_ID
        if @user.update_attributes(params[:user])
          @user.handle_retailer_image(session[:session_id])
          credit_card_information = CreditCardInformation.find_by_user_id(@user.id)

          @credit_info = if credit_card_information.blank?
           credit_information
          else
            credit_card_information
          end
          

          if @credit_info.save
          #Update Store
          @store = Store.find(UserStore.find_by_user_id(@user.id).store_id)
          @store.name= @user.business_name
          @store.description= @user.address
          if @store.save
            #Update Store Category
            @store_category=StoreCategory.find_by_store_id(@store.id)
            @store_category.category_id=UserCategory.find_by_user_id(@user.id).category_id
            if @store_category.save

              if current_user.role_id!=Role::ADMIN_USER_ID
                  if params[:payment_agreetopay]
                    make_payment(@user, @credit_info)
                  else
                    flash[:notice] =  'Retailer was successfully updated.'
                  end
                  redirect_to current_user
              else
                if params[:payment_agreetopay]
                  make_payment(@user, @credit_info)
                else
                  flash[:notice] =  'Retailer was successfully updated.'
                end
                redirect_to users_path
              end

            else
              flash[:error] = 'Error Updating Store Category'
              render action: "edit"
            end
          else
            flash[:error] = 'Error Updating Store'
            render action: "edit"
          end
        else
          flash[:error] = 'Error Saving Credit Information'
          format.html { render action: "edit" }
        end
        else
          flash[:error] = @user.errors.first#'Error Updating Retailer'
          render action: "edit"
        end
    else
      if @user.update_attributes(params[:user])
          @user.handle_retailer_image(session[:session_id])
          flash[:notice] =  'Retailer was successfully updated.'
          redirect_to current_user
      else
          flash[:error] = @user.errors.first #'Error Updating Retailer'
          render action: "edit"
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  

  def switch
     unless params[:zone].nil?
        unless params[:user].nil?
          cookies[:remember_admin_id] = current_user.id

          sign_in :user, User.find(params[:user])
          redirect_to root_path
        end
     end
  end
  def switchbacktoadmin
    unless cookies[:remember_admin_id].nil?
        sign_in :user, User.find(cookies[:remember_admin_id])
        cookies.delete :remember_admin_id
        redirect_to root_path
    end
  end

  private

  def credit_information()
    credit_info = params[:credit_info]
    expiry_date = "#{credit_info[:expiry][:year]},#{credit_info[:expiry][:month]} "
    expiry_date = DateTime.strptime(expiry_date,"%Y, %m ")
    credit_info.merge!(expiry_date: expiry_date, user_id: @user.id)
    credit_info.delete('expiry')
    @credit_info = CreditCardInformation.new(credit_info)

  end

  def make_payment(user, card_info)
    
    
    #flash[:notice]= "Error:Month #{Date.parse(params[:payment_expireDate]).strftime("%m")},Year: #{Date.parse(params[:payment_expireDate]).strftime("%Y")}"
    ActiveMerchant::Billing::Base.mode = :test
    gateway = ActiveMerchant::Billing::PaypalGateway.new(
        :login => ENV["PAYPAL_LOGIN"],
        :password => ENV["PAYPAL_PASSWORD"],
        :signature => ENV["PAYPAL_SIGNATURE"]
    )
    #    puts "------------------------------------params[:expiry]====#{params[:expiry].inspect}"
    credit_card = ActiveMerchant::Billing::CreditCard.new(
        :number             => card_info.card_number, #[:payment_cardNumber],
        :verification_value => card_info.verification_code,
        :month              => card_info.expiry_date.strftime('%m'),#params[:expiry][:month],
        :year               => card_info.expiry_date.strftime('%Y'),#params[:expiry][:year],
        :first_name         => card_info.first_name, #params[:payment_name],
        :last_name          => card_info.last_name
    )

    #testing code
    if true
      if true

        #actual code
#    if credit_card.valid?
#      response = gateway.authorize(amount, credit_card, purchase_options)
#      if response.success?
#        gateway.capture(amount, response.authorization)

        user_payment_arr = save_user_payments
        case user_payment_arr.present?
        when true
          puts "user_payment_arr=#{user_payment_arr.inspect}---------------------------"

          UserPayments.create(user_payment_arr)
          flash[:notice]= 'Payment worth  '+(amount/100).to_s+' was successfully made and Retailer saved.'
        else
          flash[:error]= 'No Subscription plan selected'
        end

      else
        flash[:notice]= "Error:response failed:: #{response.message}"
      end
    else
      flash[:notice]= "Error: credit card is not valid. #{credit_card.errors.full_messages.join('. ')}"
    end
  end



  def amount
    (params[:payment_amount].to_i*100).to_i
  end
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


  def save_user_payments
    
    user_payment_arr = []
        loop_count = params[:term].present? ? params[:term].to_i : 0
        
          subsription_amount = loop_count>1 ? (amount/loop_count) : amount
        
        plan = Plan.find(@user.active_subscription_detail.plan_id)
        
        user_payments = UserPayments.where(:user_id=>params[:id])
        last_user_payment = user_payments.present? ? user_payments.last : ''
        start_date = (last_user_payment.present? and last_user_payment.end_date >=Time.zone.now) ? last_user_payment.end_date + 1.days : Time.zone.now

        end_date = start_date + Time.days_in_month(start_date.month, start_date.year).days
        i = 0
        until i== loop_count
          i = i+1
          allowed_campaigns = plan.compaigns_per_month.capitalize=='Unlimited' ? 100000 : plan.compaigns_per_month
          user_payment_arr << {:start_date => start_date, :end_date => end_date, :month_number => i , :plan_id => plan.id,
            :plan_type => plan.plan_type,:allowed_campaigns =>allowed_campaigns, :consumed_campaigns => 0, :user_id => @user.id,
            :amount => subsription_amount, :status => 'success' }

          start_date = end_date + 1.days
          end_date = start_date + Time.days_in_month(start_date.month, start_date.year).days
        end
        
       return user_payment_arr
  end



end
