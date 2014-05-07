class Admin::ReportsController < ApplicationController

  #respond_to :html, :json, :pdf

  def index
    params[:selected_date_filter_type] ||= "current"
    @q = Deal.metasearch(params[:search])
    @deals = @q.all
    generated_and_redeemed_deals
#    @deals_view_users = @deals.collect{|deal| deal.generated_coupons}
#    @deals_view_users = @deals_view_users.flatten
    @user = User.find(params[:search][:user_current_store]) rescue ""
    respond_to do |format|
      format.html
      format.pdf { render :pdf => "reports", :template => "admin/reports/reports_list_pdf", :layout=>"pdf", :formats=> :html  }
      format.xls { send_xls_data 'reports.xls', :file => "admin/reports/reports_list_pdf.html.erb" }
    end
  end

  def retailers_list
    render :json=> User.joins(:zones).where(:admin_zones => {:id => params[:id]}).uniq.map { |u| {:name => u.name, :id => u.id} }
  end

  def deals_list
    render :json=> Deal.joins(:store).where(:stores => {:id => User.find(params[:id]).stores.first.id}).uniq.map { |u| {:name => u.title, :id => u.id} } rescue []
  end

  private
  def generated_and_redeemed_deals
    case params[:selected_date_filter_type]
    when "current"
      @graph_x = 1..Time.days_in_month(DateTime.now.month, DateTime.now.year)
      @current_date = DateTime.new(DateTime.now.year, DateTime.now.month)
      @current_date_label = @current_date.strftime("%B %Y")
      %w(redeemed_deals deals_view_users).each do |i|
        instance_variable_set("@#{i}", Array.new)
        @graph_x.each { |j| instance_variable_get("@#{i}").push(Deal.where(:id => @deals.collect(&:id)).joins(i.to_sym).where("DATE(#{i}.created_at) = ?", DateTime.new(DateTime.now.year, DateTime.now.month, j).utc.to_date.to_s(:db)).count) }
        @graph_x.each { |j| puts "#{i}.created_at >= ? AND #{i}.created_at < ?  #{DateTime.now.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00 #{DateTime.now.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00" }
      end
      @graph_x = @graph_x.to_json
    when "selected_month"
      @current_date = DateTime.new(params[:filter_year].to_i, params[:filter_month].to_i)
      @graph_x = 1..Time.days_in_month(@current_date.month, @current_date.year)
      @current_date_label = @current_date.strftime("%B %Y")
      %w(redeemed_deals deals_view_users).each do |i|
        instance_variable_set("@#{i}", Array.new)
        @graph_x.each { |j| instance_variable_get("@#{i}").push(Deal.where(:id => @deals.collect(&:id)).joins(i.to_sym).where("DATE(#{i}.created_at) = ?", DateTime.new(@current_date.year, @current_date.month, j).utc.to_date.to_s(:db)).count) }
        @graph_x.each { |j| puts "#{i}.created_at >= ? AND #{i}.created_at < ?  #{DateTime.now.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00 #{DateTime.now.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00" }
      end
      @graph_x = @graph_x.to_json
    when "selected_day"
      puts "\n\n\n\n\n\n\n#{params[:current_date]} params[:current_date]"
      puts  Date.parse(params[:current_date]).to_datetime.utc.to_date.to_s(:db)
      @current_date = Date.parse(params[:current_date]).to_datetime
      @graph_x = 0..23
      @current_date_label = @current_date.to_date
      %w(redeemed_deals deals_view_users).each do |i|
        instance_variable_set("@#{i}", Array.new)
        @graph_x.each { |j| instance_variable_get("@#{i}").push(Deal.where(:id => @deals.collect(&:id)).joins(i.to_sym).where("#{i}.created_at >= ? AND #{i}.created_at < ?", "#{@current_date.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00", "#{@current_date.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00").count) }
        (8..20).each { |j| puts "#{i}.created_at >= ? AND #{i}.created_at < ?  #{DateTime.now.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00 #{DateTime.now.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00" }
      end
      @graph_x = @graph_x.to_json
    when "range_selection"
      @current_date = "#{params[:start_date]}-#{params[:stop_date]}"
      @graph_x = Date.parse(params[:start_date])..Date.parse(params[:stop_date])
      @current_date_label = @current_date
      %w(redeemed_deals deals_view_users).each do |i|
        instance_variable_set("@#{i}", Array.new)
        @graph_x.each { |j| instance_variable_get("@#{i}").push(Deal.where(:id => @deals.collect(&:id)).joins(i.to_sym).where("DATE(#{i}.created_at) = ?", j.to_datetime.utc.to_date.to_s(:db)).count) }
      end
      @graph_x = @graph_x.collect { |c| "#{c}" }.to_json
    else
      %w(redeemed_deals deals_view_users).each do |i|
        instance_variable_set("@#{i}", Array.new)
        (8..20).each { |j| instance_variable_get("@#{i}").push(Deal.where(:id => @deals.collect(&:id)).joins(i.to_sym).where("#{i}.created_at >= ? AND #{i}.created_at < ?", "#{DateTime.now.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00", "#{DateTime.now.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00").count) }
        (8..20).each { |j| puts "#{i}.created_at >= ? AND #{i}.created_at < ?  #{DateTime.now.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00 #{DateTime.now.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00" }
      end
    end
  end
end
