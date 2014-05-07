module DealsHelper

  def self.get_back_image_url(deal,temp_img)

    if temp_img.present? and temp_img.logo_image.present?
      url = self.url_getter(temp_img.logo_image)
    elsif deal.present? and deal.background_image.present?
      
      url = self.url_getter(deal.background_image)
    else
      return ''
#      return '/supportive_image/noimage.png'
    end

    return url
  end

  

  def self.url_getter(img)
     img.url(:original).split('?')[0]
  end
  def url_generator(img)
    return img.url(:original).split('?')[0]
  end
  
  def get_item_img_url(deal,temp_img)
    if temp_img.present? and temp_img.thing_image.present?
       url= temp_img.thing_image.present? ? url_generator(temp_img.thing_image) : ''
    elsif deal.present? and deal.item_image.present?
       url = deal.item_image.present? ? url_generator(deal.item_image) : ''
    else
      return ""
    end
    return url
  end
  
  def get_retailer_img_url(deal,temp_img)
    if temp_img.present? and  temp_img.retail_image.present?
       url= temp_img.retail_image.present? ?  url_generator(temp_img.retail_image) : ''
    elsif deal.present? and deal.retailer_image.present?
       url = deal.retailer_image.present? ?  url_generator(deal.retailer_image) : ''
    else
      return ""
    end
    return url
  end
  
  def get_front_img_url(deal,temp_img)
    if temp_img.present? and (temp_img.thing_image.present? or temp_img.retail_image.present?)
       url= temp_img.thing_image.present? ? url_generator(temp_img.thing_image) : url_generator(temp_img.retail_image)
    elsif deal.present? and (deal.item_image.present? or deal.retailer_image.present?)
       url = deal.item_image.present? ? url_generator(deal.item_image) : url_generator(deal.retailer_image)
    else
      return ""
    end
    return url
  end
  # to get coupon retailer image container css to show image accordingly
  def retailer_image_container_css(deal, temp_img)

    if temp_img.present? and temp_img.front_image_container_css.present?
      temp_img.front_image_container_css
    elsif deal.present? and deal.front_image_container_css.present?
      deal.front_image_container_css
    else
      'width:163px; height:144px;'
    end
  end
  # to get coupon item image container css to show image accordingly
  def item_image_container_css(deal, temp_img)

    if temp_img.present? and temp_img.item_image_container_css.present?
      temp_img.item_image_container_css
    elsif deal.present? and deal.item_image_container_css.present?
      deal.item_image_container_css
    else
      'width: 163px; height: 144px;'
    end
  end
  def description_css(deal, temp_img)

    if temp_img.present? and temp_img.description_css.present?
      temp_img.description_css
    elsif deal.present? and deal.description_css.present?
      deal.description_css
    else
      'width: 163px; height: 144px;'
    end
  end



  def set_text(deal_wizard)
     offer_arr = DealsHelper.get_coupen_offer(deal_wizard)
     offer_text = ""
     offer_arr.each do |offer|
        offer_text += "#{offer}\n\r"
      end
      return offer_text
  end
  def self.check_type?(value)

    if value.present? and (value.class== Fixnum or value.class== Float)
      return true
    else
      return false
    end

  end



  def description_style(deal,tmp_img)

    style = ""
    
    style += description_css(deal,tmp_img)

    if session[:deal_bold]=='true' or ( session[:deal_bold].blank? and deal.bold)
      style += "font-weight: bold;"
    elsif session[:deal_bold]=='false'
      style += "font-weight: normal;"
    end
    if session[:deal_italic]=='true'or ( session[:deal_italic].blank? and deal.italic)
      style += "font-style: italic;" 
    elsif session[:deal_italic]=='false'
        style += "font-style: normal;" 
    end

     if session[:deal_underline]=='true' or ( session[:deal_underline].blank? and deal.underline)
       style += "text-decoration: underline;"
     elsif session[:deal_underline]=='false'
      style += "text-decoration: none;"
     end
    
    style += "font-size: #{session[:deal_font_size]}px;" if session[:deal_font_size].present?
    style += "font-size: #{deal.font_size}px;" if ( session[:deal_font_size].blank? and deal.font_size)

    style += "font-family: #{session[:deal_font_name]};" if session[:deal_font_name].present?
    style += "font-family: #{deal.font_name};" if  ( session[:deal_font_name].blank? and deal.font_name)

    style += "color: #{session[:deal_font_color]};" if session[:deal_font_color].present?
    style += "color: #{deal.font_color};" if ( session[:deal_font_color].blank? and deal.font_color)
    
    
    style
  end

  def get_back_color(session_color, deal)

    if session_color.present?
      session_color
    elsif deal.present? and deal.background_color.present?
      deal.background_color
    else
      '#f7f7f7'
    end
  end
  
  def preveiw_style(img, deal)
    style = ""
    style = "background-color:white;"
     #todo [taimoor noticed] in show preview have to manange this background color and image
#      style += ((session[:back_image]=="true" and img.blank?)  ? "background: #{session[:deal_background_color].blank? ? deal.background_color : session[:deal_background_color]};" : "background: url('"+img+"') no-repeat;"
    if (session[:back_image]=="true"  or session[:back_image].blank?) and img.present?
    style += "background: url('"+img+"') no-repeat;"
    else
      style +=    session[:deal_background_color].present? ? "background-color: #{get_back_color(session[:deal_background_color], deal)}!important;" : "background-color: #{(deal.try(:background_color) || "white" )} ;"
    end

  #style += (session[:back_image]=="true"  and img.present?)  ? "background: url('"+img+"') no-repeat;" : "background-color: #{session[:deal_background_color].blank? ? ((deal.present? and deal.background_color.present?) ? deal.background_color : 'rgb(245, 245, 245)') : session[:deal_background_color]}!important;"
  #      style += session[:back_image]=="true" ? "background: url('"+img+"') no-repeat;" : "background: #{cookies[:background_color]};"
      style += "background-size: 300px 300px!important;"
      style += "width:300px!important; height: 300px!important;"
      style += "max-width:300px!important; max-height: 300px!important;text-align: center;"
    style
    
  end

  def get_check_box(name, value)
#html = ''
    if(value == true)
#      <input type=checkbox name=deal[#{name}] id=deal_#{name} value=1 checked=checked />
#     html << "<%= f.check_box :#{name},{:checked => 'checked'} %>"

#    "<%= f.check_box :bold,{:checked => 'checked'} %>"
    else
#      "<input type=checkbox name=deal[#{name}] id=deal_#{name} value=1  />"
#     html <<  "<%= f.check_box :#{name}%>"
    end
#return html
  end

  def campaign_title(deal)
    (deal.target_rule.present? and deal.target_rule.name.present?) ? deal.target_rule.name : 'Campaign Name Here'
  end

  def get_value(cookie_value, db_value)
    cookie_value.present? ? cookie_value : db_value
  end
  def get_font_color(cookie_value= session[:deal_font_color], db_value=nil)
    font_color = cookie_value.present? ? cookie_value : db_value
    if font_color.blank?
      font_color = '#000000'
    end
    return font_color
  end
#  def get_font_color
#  session[:deal_font_color].present? ? session[:deal_font_color] : '#000000'
#end

  def get_description(deal)
    description = session[:deal_description].present? ? session[:deal_description] : deal.description
    if description.present?
      description_arr = description.split("\n");
      description_string=''
      description_arr.each do |arr|
        description_string = description_string+arr+"<br/>"
      end
      return description_string.html_safe
    else
      ''
    end

  end



  def get_coupen_offer

    if  session[:compaign_objectives_id].present?
      objective_id = session[:compaign_objectives_id]
      objective_hash = session[objective_id.to_sym] if objective_id.present?
      #    puts "objective_hash=#{objective_hash.inspect}"
      if objective_hash.present?
        sub_head_id = objective_hash['0']
        #       puts "sub_head_id==#{sub_head_id}------objective_hash[sub_head_id]=#{objective_hash[sub_head_id]}"
         if sub_head_id.present? and objective_hash[sub_head_id].present?
           selected_sub_obj = "#{sub_head_id+'_'+objective_hash[sub_head_id]}"
           get_text(objective_hash, objective_id, sub_head_id, objective_hash[sub_head_id], selected_sub_obj)
         else
          return ''
         end
      else
        return ''
      end
    else
      ""
    end
    
  end

  def get_text(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)

    case (objective_id)
    when '1'
      first_objective(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)
    when '2'
      second_objective(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)
    when '3'
      third_objective(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)
    when '4'
      fourth_objective(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)
    when '5'
      fifth_objective(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)
    else
      ""
    end
    
  end

  def first_objective(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)
    #      puts  "in first object check it yar :D sub_head_id=#{sub_head_id}, selected_sub_obj_id=#{selected_sub_obj_id.inspect}, selected_sub_obj=#{selected_sub_obj.inspect}"
    #      puts "chec :DD>>>> #{session[objective_id.to_sym][selected_sub_obj]}"
    #      puts "chec :DD>>>> #{session[objective_id.to_sym][selected_sub_obj]['1']} and get #{session[objective_id.to_sym][selected_sub_obj]['2']} free!"
    case(sub_head_id)
    when '1'
      case(selected_sub_obj_id)
      when '1'
        return "Buy one, get one free!"
      when '2'
        return "Buy #{objective_hash[selected_sub_obj]['1']} and get #{objective_hash[selected_sub_obj]['2']} free!"
      when '3'
        return "Buy #{objective_hash[selected_sub_obj]['1']} and get $#{objective_hash[selected_sub_obj]['2']} off your purchase!"
      when '4'
        return "Buy #{objective_hash[selected_sub_obj]['1']} and get % #{objective_hash[selected_sub_obj]['2']} off!"
      when '5'
        return "Buy #{objective_hash[selected_sub_obj]['1']} and get % #{objective_hash[selected_sub_obj]['2']} off the next unit!"
      end
    when '2'
      case(selected_sub_obj_id)
      when '1'
        return "Spend $#{objective_hash[selected_sub_obj]['1']} or more in store and receive $#{objective_hash[selected_sub_obj]['2']} off your purchase!"
      when '2'
        return "Spend $#{objective_hash[selected_sub_obj]['1']} or more in store and receive #{objective_hash[selected_sub_obj]['2']}% off your purchase!"
      when '3'
        return "Spend $#{objective_hash[selected_sub_obj]['1']} or more in store and receive a #{objective_hash[selected_sub_obj]['2']} with your purchase!"
      end
    when '3'
      case(selected_sub_obj_id)
      when '1'
        return "Come in with #{objective_hash[selected_sub_obj]['1']} or more friends, spend $#{objective_hash[selected_sub_obj]['2']} or more in store as a group and receive $#{objective_hash[selected_sub_obj]['3']} off your total group purchase!"
      when '2'
        return "Come in with #{objective_hash[selected_sub_obj]['1']} or more friends, spend $#{objective_hash[selected_sub_obj]['2']} or more in store as a group and receive #{objective_hash[selected_sub_obj]['3']}% off your total group purchase!"
      end
    when '4'
      case(selected_sub_obj_id)
      when '1'
        return "Order #{objective_hash[selected_sub_obj]['1']} and receive a $#{objective_hash[selected_sub_obj]['2']} for $#{objective_hash[selected_sub_obj]['3']} more!"
      end
    else
      return ""
    end
    
  end

  def second_objective(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)
    #      puts  "in first object check it yar :D sub_head_id=#{sub_head_id}, selected_sub_obj_id=#{selected_sub_obj_id.inspect}, selected_sub_obj=#{selected_sub_obj.inspect}"
    #      puts "chec :DD>>>> #{session[objective_id.to_sym][selected_sub_obj]}"
    #      puts "chec :DD>>>> #{session[objective_id.to_sym][selected_sub_obj]['1']} and get #{session[objective_id.to_sym][selected_sub_obj]['2']} free!"
    case(sub_head_id)
    when '1'
      case(selected_sub_obj_id)
      when '1'
        return "Come celebrate #{objective_hash[selected_sub_obj]['1']} with us and receive #{objective_hash[selected_sub_obj]['2']}% off your purchase storewide!"
      when '2'
        return "Come celebrate #{objective_hash[selected_sub_obj]['1']} with us. Spend $#{objective_hash[selected_sub_obj]['2']} or more in store and receive $#{objective_hash[selected_sub_obj]['3']} off your purchase!"
      when '3'
        return "Come celebrate #{objective_hash[selected_sub_obj]['1']} with us. Spend $#{objective_hash[selected_sub_obj]['2']} or more in store and receive #{objective_hash[selected_sub_obj]['3']}% off your purchase!"
      when '4'
        return "Purchase #{objective_hash[selected_sub_obj]['1']} and receive #{objective_hash[selected_sub_obj]['2']}% off!"
      end
    when '2'
      case(selected_sub_obj_id)
      when '1'
        return "Present this coupon in store and receive a free #{objective_hash[selected_sub_obj]}!"
      when '2'
        return "Spend $#{objective_hash[selected_sub_obj]['1']} in store and receive a #{objective_hash[selected_sub_obj]['2']} with your purchase!"
      end
    when '3'
      case(selected_sub_obj_id)
      when '1'
        return "Come in with #{objective_hash[selected_sub_obj]['1']} or more friends, spend $#{objective_hash[selected_sub_obj]['2']} or more in store as a group and receive $#{objective_hash[selected_sub_obj]['3']} off your total group purchase!"
      when '2'
        return "Come in with #{objective_hash[selected_sub_obj]['1']} or more friends, spend $#{objective_hash[selected_sub_obj]['2']} or more in store as a group and receive #{objective_hash[selected_sub_obj]['3']}% off your total group purchase!"
      end
    else
      return ""
    end
  end
  

  
  def third_objective(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)
    #      puts  "in first object check it yar :D sub_head_id=#{sub_head_id}, selected_sub_obj_id=#{selected_sub_obj_id.inspect}, selected_sub_obj=#{selected_sub_obj.inspect}"
    #      puts "chec :DD>>>> #{session[objective_id.to_sym][selected_sub_obj]}"
    #      puts "chec :DD>>>> #{session[objective_id.to_sym][selected_sub_obj]['1']} and get #{session[objective_id.to_sym][selected_sub_obj]['2']} free!"
    case(sub_head_id)
    when '1'
      case(selected_sub_obj_id)
      when '1'
        return "Buy one, get one free!"
      when '2'
        return "Buy #{objective_hash[selected_sub_obj]['1']} and get #{objective_hash[selected_sub_obj]['2']} free!"
      when '3'
        return "Buy #{objective_hash[selected_sub_obj]['1']} and get $#{objective_hash[selected_sub_obj]['2']} off your purchase!"
      when '4'
        return "Buy #{objective_hash[selected_sub_obj]['1']} and get #{objective_hash[selected_sub_obj]['2']}% off!"
      when '5'
        return "Buy #{objective_hash[selected_sub_obj]['1']} and get #{objective_hash[selected_sub_obj]['2']}% off the next unit!"
      end
    when '2'
      case(selected_sub_obj_id)
      when '1'
        return "Present this coupon to receive a #{objective_hash[selected_sub_obj]['1']}% off #{objective_hash[selected_sub_obj]['2']}!"
      end
    when '3'
      case(selected_sub_obj_id)
      when '1'
        return "Purchase #{objective_hash[selected_sub_obj]['1']} by #{objective_hash[selected_sub_obj]['2']} and receive #{objective_hash[selected_sub_obj]['3']}% off!"
      end
    else
      return ""
    end
  end
  
  def fourth_objective(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)
    #      puts  "in first object check it yar :D sub_head_id=#{sub_head_id}, selected_sub_obj_id=#{selected_sub_obj_id.inspect}, selected_sub_obj=#{selected_sub_obj.inspect}"
    #      puts "chec :DD>>>> #{session[objective_id.to_sym][selected_sub_obj]}"
    #      puts "chec :DD>>>> #{session[objective_id.to_sym][selected_sub_obj]['1']} and get #{session[objective_id.to_sym][selected_sub_obj]['2']} free!"
    case(sub_head_id)
    when '1'
      case(selected_sub_obj_id)
      when '1'
        return "Come back and celebrate #{objective_hash[selected_sub_obj]['1']} with us and receive #{objective_hash[selected_sub_obj]['2']}% off your purchase storewide!"
      when '2'
        return "Come back and celebrate #{objective_hash[selected_sub_obj]['1']} with us. Spend $#{objective_hash[selected_sub_obj]['2']} or more in store and receive $#{objective_hash[selected_sub_obj]['3']} off your purchase!"
      when '3'
        return "Come back and celebrate #{objective_hash[selected_sub_obj]['1']} with us. Spend $#{objective_hash[selected_sub_obj]['2']} or more in store and receive #{objective_hash[selected_sub_obj]['3']}% off your purchase!"
      when '4'
        return "Purchase #{objective_hash[selected_sub_obj]['1']} and receive #{objective_hash[selected_sub_obj]['2']}% off!"
      end
    when '2'
      case(selected_sub_obj_id)
      when '1'
        return "Present this coupon in store and receive a #{objective_hash[selected_sub_obj]}!"
      when '2'
        return "Spend $#{objective_hash[selected_sub_obj]['1']} in store and receive a #{objective_hash[selected_sub_obj]['2']} with your purchase!"
      end
    when '3'
      case(selected_sub_obj_id)
      when '1'
        return "As thanks for your past business, we'd like to offer you #{objective_hash[selected_sub_obj]['1']}% off your purchase on your next visit!"
      when '2'
        return "Exclusive deal for past customers. Spend $#{objective_hash[selected_sub_obj]['1']} or more and receive $#{objective_hash[selected_sub_obj]['2']} off your purchase!"
      when '3'
        return "Exclusive deal for past customers. Spend $#{objective_hash[selected_sub_obj]['1']} or more and receive #{objective_hash[selected_sub_obj]['2']}% off your purchase!"
      end
    else
      return ""
    end
  end

  def fifth_objective(objective_hash, objective_id, sub_head_id, selected_sub_obj_id, selected_sub_obj)
    #      puts  "in first object check it yar :D sub_head_id=#{sub_head_id}, selected_sub_obj_id=#{selected_sub_obj_id.inspect}, selected_sub_obj=#{selected_sub_obj.inspect}"
    #      puts "chec :DD>>>> #{session[objective_id.to_sym][selected_sub_obj]}"
    #      puts "chec :DD>>>> #{session[objective_id.to_sym][selected_sub_obj]['1']} and get #{session[objective_id.to_sym][selected_sub_obj]['2']} free!"
    case(sub_head_id)
    when '1'
      case(selected_sub_obj_id)
      when '1'
        return "Purchase #{objective_hash[selected_sub_obj]['1']} in the next #{objective_hash[selected_sub_obj]['2']} and receive #{objective_hash[selected_sub_obj]['3']}% off!"
      end
    else
      return ""
    end
  end
  
end
