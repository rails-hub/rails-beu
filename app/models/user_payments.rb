class UserPayments < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan
  attr_accessible :user_id,:amount,:status, :month_number, :start_date, :end_date, :allowed_campaigns, :consumed_campaigns, :plan_id, :plan_type


 
 def self.get_change_subscription_amount(plan, user_payments)
    first_user_payment = user_payments.first
    plan_allowed_campaigns = plan.compaigns_per_month.capitalize=='Unlimited' ? 100000 : plan.compaigns_per_month
    if plan_allowed_campaigns.to_i > first_user_payment.allowed_campaigns or (plan.get_amount> first_user_payment.get_payment_amount and plan_allowed_campaigns.to_i==first_user_payment.allowed_campaigns)
       total_extra_payment = (plan.get_amount - first_user_payment.get_payment_amount) * user_payments.count
       return 'up_grade', total_extra_payment.to_i
    elsif plan_allowed_campaigns.to_i < first_user_payment.allowed_campaigns
      #todo refund related cod to do
      # downgrad will start from next month so have to -1 from total months subscriptions
      return_amount  = (first_user_payment.get_payment_amount - plan.get_amount) * (user_payments.count - 1)
      return 'down_grade', return_amount.to_i
    else
      return ''
    end
  end

  def self.update_subscription(plan, user_payments)

    plan_allowed_campaigns = plan.compaigns_per_month.capitalize=='Unlimited' ? 100000 : plan.compaigns_per_month
    update_payment = {:plan_id => plan.id, :amount => plan.get_amount, :plan_type => plan.plan_type, :allowed_campaigns => plan_allowed_campaigns}
    user_payments.each do |user_payment|
      user_payment.update_attributes(update_payment)
    end

  end

  def self.renew_subscription(plan, user_payments, loop_count, user_id)
    user_payment_arr = []
        
        last_user_payment = user_payments.last
        start_date = (last_user_payment.present? and last_user_payment.end_date >= Time.zone.now) ? last_user_payment.end_date + 1.days : Time.zone.now
        end_date = start_date + Time.days_in_month(start_date.month, start_date.year).days
        
        i = 0
        allowed_campaigns = plan.compaigns_per_month.capitalize=='Unlimited' ? 100000 : plan.compaigns_per_month
        until i== loop_count
          i = i+1
          user_payment_arr << {:start_date => start_date, :end_date => end_date, :month_number => i , :plan_id => plan.id,
            :plan_type => plan.plan_type,:allowed_campaigns =>allowed_campaigns, :consumed_campaigns => 0, :user_id => user_id,
            :amount => plan.price*100 , :status => 'success' }

          start_date = end_date + 1.days
          end_date = start_date + Time.days_in_month(start_date.month, start_date.year).days
#          puts "month-->#{start_date}----year=#{start_date.year}-------days=#{Time.days_in_month(start_date.month, start_date.year)}"
#          puts "end-:->month-->#{end_date}------year=#{end_date.year}---------days=#{Time.days_in_month(end_date.month, end_date.year)}"
        end

       return user_payment_arr
  end


#  def month_remaining_days(start_date)
#
#    start_month_days = Time.days_in_month(start_date.month, start_date.year).days
#    current_day_no = Time.zone.now.day
#  end
#

  def get_payment_amount
    self.amount.to_i
  end

end
