desc "expire or renew user subescription"

task :auto_expire_payment => :environment do
  auto_renew_users = User.joins(:user_paymentss).where("DATE(user_payments.end_date) = :date", :date=>DateTime.now.to_date)
  auto_renew_users.each do |user|
    begin
      if user.joins(:credit_card_informations).where("DATE(credit_card_informations.expire_date) = ? ", DateTime.now.to_date).present?
        credit = plan  = ""
        plan = if user.subscriptions_details.count == 1 then
                 user.subscriptions_details.first
               else
                 user.subscriptions_detials.where("id > ?", user.active_subscription_detail.id).first
               end
        if plan.present? 
          user.subscriptions_details.update_all({:is_active=>false}, ["id <> ? ", plan.id])
          plan.update_attribtue(:is_active, true)
        end
        credit = if user.credit_card_informations.count == 1 then
                   user.credit_card_informations.first
                 else
                   user.credit_card_informations.where(:is_active=>true).first
                 end
        if credit.present? && plan.present?
          ActiveMerchant::Billing::Base.mode = :test
          gateway = ActiveMerchant::Billing::PaypalGateway.new(
            :login => ENV["PAYPAL_LOGIN"],
            :password => ENV["PAYPAL_PASSWORD"],
            :signature => ENV["PAYPAL_SIGNATURE"]
          )
          credit_card = ActiveMerchant::Billing::CreditCard.new(
            :number             => credit.card_number,
            :verification_value => credit.verification_code,
            :month              => credit.expiry_date.strftime('%m'),#params[:expiry][:month],
            :year               => credit.expiry_date.strftime('%Y'),#params[:expiry][:year],
            :first_name         => credit.first_name,
            :last_name          => credit.last_name
          )
          UserPayments.create(:user=>user, :amount=>plan.plan.price, :status=>"success", :allowed_campaigns=>plan.plan.compaigns_per_month, :start_date=>DateTime.now, :end_date=> DateTime.now + 1.month)
        end
      else
        user.subscription_details.update_all(:is_active=>false)
        user.credit_card_informatioms.update_all(:is_active=>false)
      end
    rescue  Exception=>e
      puts "******************** #{e}"
    end
  end
end
