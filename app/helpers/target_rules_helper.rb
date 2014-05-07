module TargetRulesHelper
include DealsHelper

  def get_age_categories(target_rule)    
    return '12-17 & 18-35 & 36-44 & 45 and older' if target_rule.all==true
    
    ages = []
    ages << '12-17' if target_rule.age_12_17==true
    ages << '18-35' if target_rule.age_18_35==true
    ages << '36-44' if target_rule.age_36_44==true
    ages << '45 and older' if target_rule.age_45_and_older==true
    
    return ages.join(' & ') if ages != []
    return 'N/A'
  end

  def get_genders(target_rule)
    return 'Male & Female' if target_rule.all==true
    return 'Male & Female' if target_rule.male==true and target_rule.female==true
    return 'Male' if target_rule.male==true and target_rule.female!=true
    return 'Female' if target_rule.male!=true and target_rule.female==true
    return 'N/A'
  end

  def allowed_customer(target_rule)
    return 'Yes & No' if target_rule.all==true or (target_rule.is_pastcustomer== true and target_rule.not_pastcustomer== true)
    return 'Yes' if target_rule.is_pastcustomer== true and target_rule.not_pastcustomer!= true
    return 'No' if target_rule.is_pastcustomer!= true and target_rule.not_pastcustomer== true
    return 'N/A'
  end

  def campaign_name(name)
    return name.present? ? name : 'N/A'
  end

  def gift_or_seasonal_item(is_gift)
    is_gift.present? ? (is_gift==true ? 'Yes' : 'No') : 'No'
  end

  def get_start_date(start_date, is_today)
    return Time.zone.now.strftime('%B %d, %Y') if is_today=='1'
    return start_date.present? ? @target_rule.start_date.strftime('%B %d, %Y') : 'N/A'
  end

  def show_preview_image(deal, temp_image)
    puts "temp_image.final_image===#{temp_image.final_image.url(:original).split('?')[0]}"
    if temp_image.present? and temp_image.final_image
      url_generator(temp_image.final_image)
    elsif deal.present? and deal.coupen_image
      url_generator(deal.coupen_image)
    else
      '/supportive_image/noimage.png'
    end
    
  end

end
