class TargetRule < ActiveRecord::Base
  belongs_to :deal
  attr_accessible :age_category, :end_date, :start_date, :all_age, :birthday, :gender, :past_customer, :deal_id,
    :age_to,  :age_from, :name, :stoday, :flag, :age_rule, :all,
    :age_12_17, :age_18_35, :age_36_44, :age_45_and_older, :male, :female, :today, :this_week, :within_30_days,
    :is_pastcustomer, :not_pastcustomer, :gift_or_seasonal_item
  attr_accessor :age_category, :stoday, :flag, :age_rule

  #scopes
  scope :get_rules_ids, select('id')
  scope :last_minute_deals, where(:end_date=> (Time.zone.now)..((Time.zone.now)+59.minutes))
  scope :current_user_deals, lambda { |u| joins(:deal=>[:users]).where(:users=>{:id=>u.id}).uniq  }
  
  after_save  do |target_rule|
    
    age_category = target_rule.age_category
    if age_category.present?
      age_category = age_category.gsub('and','-').gsub(' ','').split('-')
      age_from = age_category.first
      age_to = age_category.last

      if target_rule.age_from != age_from or target_rule.age_to != age_to
        rule_attributes = {:age_from => age_from, :age_to => age_to}
        target_rule.update_attributes(rule_attributes)
      end
    end

  end
  #  :start_day, :end_day, :start_month, :end_month, :start_year, :end_year, :start_time, :end_time, :stoday, :etoday
  #  attr_accessible :s_date, :e_date,:start_day, :end_day, :start_month, :end_month, :start_year, :end_year, :start_time, :end_time, :stoday, :etoday

  #  def age_category
  #    if self.age_to== 'older'
  #    [self.age_from, self.age_to].join(' and ')
  #    else
  #    [self.age_from, self.age_to].join('-')
  #    end
  #  end
  #
  #  def age_category=(age_category)
  #    split = age_category.gsub('and','-').gsub(' ','').split('-')
  #    self.age_from = split.first
  #    self.age_to = split.last
  #
  #  end

  def self.get_rule_colum_name(age)
    if(age>=12 and age<=17)
      return 'age_12_17'
    elsif(age>=18 and age<=35)
      return 'age_18_35'
    elsif(age>=36 and age<=44)
      return 'age_36_44'
    elsif(age>=45)
      return 'age_45_and_older'
    end
    return false
  end
  def get_rule_colum_name(age)
    if(age>=12 and age<=17)
      return 'age_12_17'
    elsif(age>=18 and age<=35)
      return 'age_18_35'
    elsif(age>=36 and age<=44)
      return 'age_36_44'
    elsif(age>=45)
      return 'age_45_and_older'
    end
    return false
  end



end
