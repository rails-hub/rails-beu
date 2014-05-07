module ApplicationHelper


  def display_value(value)
    return value.present? ? value : 'N/A'
  end

  def site_selected_tab

  end

  def remove_square_brackets(value)
    value.gsub(/\A\[/, "").gsub(/\]\z/ ,'').split(',')
  end

  def last_digits(number)    
      number.to_s.length <= 4 ? number : number.to_s.slice(-4..-1) 
  end

  def mask(number)
     "XXXX-XXXX-XXXX-#{last_digits(number)}"
  end

  def count_arr_for(v)
    c = 0; v.each { |a| c+= a.to_i }; c
  end
  def deals_list_for id
    Deal.joins(:store).where(:stores=>{:id=>User.find(id).stores.first.id}).uniq.collect { |u| [ u.title, u.id ] } rescue ["", ""]
  end 
end
