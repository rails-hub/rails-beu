module UsersHelper


  def get_service_type(service_type)
    
    case service_type
    when 's'
      'Self Service'
    when 'f'
      'Full Service'
    else
      'N/A'
    end
  end

  def get_plan_type(plan)
     return (plan.present? and plan.title.present?) ? plan.title : 'N/A'
  end

  def get_remaining_campaigns(user_payment)
    
   return user_payment.allowed_campaigns - user_payment.consumed_campaigns
  end

  def subscription_txt(user_payment)
#   puts "user_payment===#{user_payment.inspect}"
   if  params[:action]=='edit'
     case user_payment.present?
     when true
       return "Current Subscription Plan, Choose from One of the following Subscription Plans to change it:"
     else
     return "Choose from One of the following Subscription Plans:"
     end

   else
     return "Choose from One of the following Subscription Plans:"
   end
  end

  def get_selected_sub_plan_id(user_payment)
    if  params[:action]=='edit' and user_payment.present?
      plan = user_payment.plan
      return "#{plan.title}@#{plan.compaigns_per_month}@#{plan.id}"
    end

  end

  def check_service(service_type,user_payment)
    if  params[:action]=='edit'
      if user_payment.present? and service_type==user_payment.plan_type
      
        return user_payment.plan_type
      else
        return "s"
      end

    else
      return "s"
    end
  end


  def checked_radio(user_payment, counter,plan_id)
    if user_payment.present? and plan_id==user_payment.plan_id
      return true
    else
     return counter==0 ? true : false
    end

  end

  def get_reatailer_pic(user, tmp_user=nil)
    
    return tmp_user.retailer_image.url(:thumb) if tmp_user.present? and tmp_user.retailer_image.present?
    return user.retailer_img_url.present? ? user.retailer_img_url.url(:thumb) : "/images/no_image.png"
    #     if tmp_user.present? and tmp_user.retailer_image.present?
    #       puts "------------"+tmp_user.retailer_image.url(:thumb)
    #       return tmp_user.retailer_image.url(:thumb)
    #     end
    #
    #    if user.retailer_img_url.present?
    #      puts "---------->>>>>>--"+user.retailer_img_url.url(:thumb)
    #      return  user.retailer_img_url.url(:thumb)
    #    else
    #      return  "/images/no_image.png"
    #    end

    
  end

end
