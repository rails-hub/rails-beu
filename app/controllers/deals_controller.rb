class DealsController < ApplicationController
  # GET /deals
  # GET /deals.json
  include SharedCoupen
  require 'imgkit'
  require 'rest_client'
  require 'stringio'

  skip_before_filter :session_cookies_remove, :except => [:index]
#  require 'aws/s3'
# include AWS::S3
   def index

    if current_user.stores.blank?
      flash[:error] = 'Retailer is not assosiated with any Store'
    end
    @deals = []
    if params[:archive]
      @deals = Deal.joins(:target_rule).where("deals.is_inactive = ?", true).where(:store_id => current_user.stores.first.id) if current_user.stores.present? and current_user.stores.first.present?
    else
      @deals = Deal.active.not_expire.where(:store_id => current_user.stores.first.id) if current_user.stores.present? and current_user.stores.first.present?
    end

    params[:selected_date_filter_type] ||= "current"
    if current_user.try(:stores).try(:present?)
      @q = Deal.where(:store_id => current_user.stores.first.id).search(params[:q])
    else
      @q = current.deals.search(params[:q])
    end
    @user ||= current_user
    @graph_deals = @q.result(:distinct => true)
    #    @graph_deals = @deals
    if params[:q] and params[:q][:id_eq]
      @deal = Deal.find_by_id(params[:q][:id_eq])
    end
    generated_and_redeemed_deals
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @deals }
      format.pdf { render :pdf => "admin_reports", :template => "admin/reports/reports_list_pdf", :layout=>"pdf", :formats=> :html  }
      format.xls { send_xls_data 'reports.xls', :file => "admin/reports/reports_list_pdf.html.erb" }
    end
  end

  # GET /deals/1
  # GET /deals/1.json
  def show
    @deal = Deal.find(params[:id])
    @tmp_img = nil
    @deal_wizard = @deal.deals_wizard
    @target_rule = @deal.target_rule
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deal }
    end
  end


  # GET /deals/1/edit
  def edit

    @deal = Deal.find(params[:id])

    get_tmp_coupen

  end

  # GET /deals/new
  # GET /deals/new.json
  def new
    #Begin  ------Setting Default Values of cookies
    #    remove_sessions
    cookies[:back_image]= "true"
    cookies[:back_color]= "false"
    #End
    @deal = Deal.new(session[:deal])
    get_tmp_coupen

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @deal }
    end
  end

  def geneate_preview_session
    preview_data = params[:preview_data].present? ? params[:preview_data].split('&') : []

    preview_data.each do |data|
      data = data.split('=')
      data[0]='back_image' if data[0]== 'deal_back_image_or_color_true'
#       deal_preview.merge!({"#{data[0].to_sym}" => data[1]})
      session["#{data[0].to_sym}"] = data[1]
    end

  end

  def set_preview

    geneate_preview_session
    @deal = params[:deal_id].present? ? Deal.find(params[:deal_id]) : Deal.new(session[:deal])
#    session["#{params[:attr_name].to_sym}"] = params[:attr_value]
    get_tmp_coupen

    render :partial => 'preview', :locals => {:deal => @deal, :tmp_img => @tmp_img, :deal_wizard => @deal_wizard}

  end


  def compaign_params
    session[:deal] = params[:deal] if params[:deal].present?
    @deal = params[:deal_id].present? ? Deal.find(params[:deal_id]) : Deal.new(session[:deal])
    get_tmp_coupen
    html= render_to_string(:partial => 'preview', :locals => {:deal => @deal, :tmp_img => @tmp_img, :deal_wizard => @deal_wizard})
    html_2_image(@tmp_img, html, 'small')
    large_html = Deal.get_large_img_html(html)
    html_2_image(@tmp_img, large_html, 'large')

    respond_to do |format|
      format.html { redirect_to set_params_path(:deal_id => params[:deal_id]) }
    end

  end

  def html_2_image(tmp_img, html, image_type)
    url1 = $domain+'/stylesheets/style.css'
    url2 = $domain+'/stylesheets/wkit.css'
    url3 = $domain+'/stylesheets/public.css'
    css1 = StringIO.new(RestClient.get(url1))
    css2 = StringIO.new(RestClient.get(url2))
    css3 = StringIO.new(RestClient.get(url3))
    kit = IMGKit.new(html)
    kit.stylesheets << css1
    kit.stylesheets << css2
    kit.stylesheets << css3
    img = kit.to_img(:png)

    file = Tempfile.new(["template_#{tmp_img.id}", '.png'], 'tmp', :encoding => 'ascii-8bit')
    file.write(img)
    file.flush

    case image_type
      when 'small'
        tmp_img.local_final_image = file
        tmp_img.save
        file.unlink
        tmp_img.reprocess_final_image(image_type)
      when 'large'
        tmp_img.local_final_large_img = file
        tmp_img.save
        file.unlink
        tmp_img.reprocess_final_large_image(image_type)
    end

  end


  #create and update deal wizard and its relvent deal_compaign_objectives table
  def create_update_deal_wizard(new = false, deal_wizard = nil)

    if session[:deals_wizard].present?
      case new
        when true
          session[:deals_wizard][:deal_id] = @deal.id
          @deals_wizard = DealsWizard.new(session[:deals_wizard])
          @deals_wizard.save
        else
          deal_wizard.update_attributes(session[:deals_wizard])
      end
    end
  end

  def create_update_target_rule(new = false, target_rule = nil)

    if session[:target_rule].present?
      case new
        when true
          session[:target_rule][:deal_id] = @deal.id
          @target_rule = TargetRule.new(session[:target_rule])
          @target_rule.save
          @target_rule.update_attribute(:start_date, Time.zone.now+5.hours) if @target_rule.stoday=='1'
        else
          target_rule.update_attributes(session[:target_rule])
          target_rule.update_attribute(:start_date, Time.zone.now+5.hours) if target_rule.stoday=='1'
      end
    end
  end

  def handle_images(deal)
    deal.handle_images(session[:session_id]) if deal.present?
  end

  def campaigns_remaining?(user_payment)
    target_rule = TargetRule.new(session[:target_rule])
    if Deal.check_campaign_rules?(target_rule)==true and (user_payment.allowed_campaigns > user_payment.consumed_campaigns + 1)
      true
    elsif Deal.check_campaign_rules?(target_rule)==false and (user_payment.allowed_campaigns > user_payment.consumed_campaigns)
      true
    else
      false
    end
  end


  def save

    user_payment = UserPayments.where(["user_id=? and start_date<=? and end_date>=?", current_user.id, Time.zone.now, Time.zone.now]).first

    if user_payment.present? and campaigns_remaining?(user_payment)
      session[:deal].merge!(:store_id => current_user.stores.first.id) if current_user.stores.present? and current_user.stores.first.present?
      if params[:deal_id].present?
        @deal = Deal.find_by_id(params[:deal_id])
        # update deal

        respond_to do |format|
          if @deal.update_attributes(session[:deal])

            handle_images(@deal)
            @deal.deals_wizard.nil? ? create_update_deal_wizard(true) : create_update_deal_wizard(false, @deal.deals_wizard)
            @deal.target_rule.nil? ? create_update_target_rule(true) : create_update_target_rule(false, @deal.target_rule)
            @deal.campaigns_deduction(user_payment)
            remove_sessions
            format.html { redirect_to deals_path }
          else
            flash[:error] = 'Unable to update Deal.'
            format.html { redirect_to edit_deal_path(:id => @deal.id) }
          end
        end

      else
        # create new Deal

        @deal = Deal.new(session[:deal])
        respond_to do |format|
          if @deal.save
            handle_images(@deal)
            create_update_deal_wizard(true)
            create_update_target_rule(true)
            @deal.campaigns_deduction(user_payment)
            remove_sessions
            format.html { redirect_to deals_path }

          else
            flash[:error] = 'Unable to update Deal.'
            format.html { redirect_to edit_deal_path(:id => @deal.id), notice: 'Unable to create Deal.' }
          end
        end # respond_to block end

      end #main if condition end
    else
      flash[:error] = 'Unable to create Deal, check your remaining campaigns'
      redirect_to deals_path
    end
  end

  def upload_img

    name = params[:upload][:file].original_filename
    directory = "public/coupen_img"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(params[:upload][:file].read) }
    flash[:notice] = "File uploaded"

  end


  # POST /deals
  # POST /deals.json
  def create
    @deal = Deal.new(params[:deal])

    respond_to do |format|
      if @deal.save

        case params[:commit]
          when "Next"
            format.html { redirect_to set_params_path(:deal_id => @deal.id.to_i) }

#        when "Deal Wizard"
#          format.html{ redirect_to objectives_deals_wizards_path(:deal_id => @deal.id.to_i) }

          else
            format.html { redirect_to edit_deal_path(:id => @deal.id), notice: 'Deal was successfully created.' }
        end

        format.json { render json: @deal, status: :created, location: @deal }
      else
        format.html { render action: "new" }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /deals/1
  # PUT /deals/1.json
  def update
    @deal = Deal.find(params[:id])

    respond_to do |format|
      if @deal.update_attributes(params[:deal])
        if params[:commit]=="Next"
          format.html { redirect_to set_params_path(:deal_id => @deal.id.to_i) }
        elsif params[:commit] == "status_update"
          format.html { redirect_to deals_path, :notice => "Deal was successfully updated." }
        else
          format.html { redirect_to edit_deal_path(:id => @deal.id), notice: 'Deal was successfully updated.' }
        end

#        format.html { redirect_to @deal, notice: 'Deal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deals/1
  # DELETE /deals/1.json
  def destroy
    @deal = Deal.find_by_id(params[:id])
    @deal.deals_wizard.destroy if @deal.deals_wizard.present?
    @deal.target_rule.destroy if @deal.target_rule.present?
    @deal.destroy


    respond_to do |format|
      format.html { redirect_to deals_url }
      format.json { head :no_content }
    end
  end


  #helping functions

  def remove_sessions
    session.delete :deal
    session.delete :deals_wizard
    session.delete :target_rule
    session.delete :deal_description
    session.delete :back_image
    session.delete :deal_font_name
    session.delete :deal_font_color
    session.delete :deal_font_size
    session.delete :deal_bold
    session.delete :deal_italic
    session.delete :deal_underline
    session.delete :deal_background_color

    #Begin Remove Cookies
    cookies.delete :back_image
    cookies.delete :back_color
    cookies.delete :deal_title
    #End
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
          @graph_x.each { |j| instance_variable_get("@#{i}").push(Deal.where(:id => @graph_deals.collect(&:id)).joins(i.to_sym).where("DATE(#{i}.created_at) = ?", DateTime.new(DateTime.now.year, DateTime.now.month, j).utc.to_date.to_s(:db)).count) }
          @graph_x.each { |j| puts "#{i}.created_at >= ? AND #{i}.created_at < ?  #{DateTime.now.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00 #{DateTime.now.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00" }
        end
        @graph_x = @graph_x.to_json
      when "selected_month"
        @current_date = DateTime.new(params[:filter_year].to_i, params[:filter_month].to_i)
        @graph_x = 1..Time.days_in_month(@current_date.month, @current_date.year)
        @current_date_label = @current_date.strftime("%B %Y")
        %w(redeemed_deals deals_view_users).each do |i|
          instance_variable_set("@#{i}", Array.new)
          @graph_x.each { |j| instance_variable_get("@#{i}").push(Deal.where(:id => @graph_deals.collect(&:id)).joins(i.to_sym).where("DATE(#{i}.created_at) = ?", DateTime.new(@current_date.year, @current_date.month, j).utc.to_date.to_s(:db)).count) }
          @graph_x.each { |j| puts "#{i}.created_at >= ? AND #{i}.created_at < ?  #{DateTime.now.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00 #{DateTime.now.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00" }
        end
        @graph_x = @graph_x.to_json
      when "selected_day"
        puts "\n\n\n\n\n\n\n#{params[:current_date]} params[:current_date]"
        puts Date.parse(params[:current_date]).to_datetime.utc.to_date.to_s(:db)
        @current_date = Date.parse(params[:current_date]).to_datetime
        @graph_x = 0..23
        @current_date_label = @current_date.to_date
        %w(redeemed_deals deals_view_users).each do |i|
          instance_variable_set("@#{i}", Array.new)
          @graph_x.each { |j| instance_variable_get("@#{i}").push(Deal.where(:id => @graph_deals.collect(&:id)).joins(i.to_sym).where("#{i}.created_at >= ? AND #{i}.created_at < ?", "#{@current_date.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00", "#{@current_date.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00").count) }
          (8..20).each { |j| puts "#{i}.created_at >= ? AND #{i}.created_at < ?  #{DateTime.now.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00 #{DateTime.now.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00" }
        end
        @graph_x = @graph_x.to_json
      when "range_selection"
        @current_date = "#{params[:start_date]}-#{params[:stop_date]}"
        @graph_x = Date.parse(params[:start_date])..Date.parse(params[:stop_date])
        @current_date_label = @current_date
        %w(redeemed_deals deals_view_users).each do |i|
          instance_variable_set("@#{i}", Array.new)
          @graph_x.each { |j| instance_variable_get("@#{i}").push(Deal.where(:id => @graph_deals.collect(&:id)).joins(i.to_sym).where("DATE(#{i}.created_at) = ?", j.to_datetime.utc.to_date.to_s(:db)).count) }
        end
        @graph_x = @graph_x.collect { |c| "#{c}" }.to_json
      else
        %w(redeemed_deals deals_view_users).each do |i|
          instance_variable_set("@#{i}", Array.new)
          (8..20).each { |j| instance_variable_get("@#{i}").push(Deal.where(:id => @graph_deals.collect(&:id)).joins(i.to_sym).where("#{i}.created_at >= ? AND #{i}.created_at < ?", "#{DateTime.now.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00", "#{DateTime.now.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00").count) }
          (8..20).each { |j| puts "#{i}.created_at >= ? AND #{i}.created_at < ?  #{DateTime.now.utc.to_date.to_s(:db)} #{("0" if j < 10)}#{j}:00:00 #{DateTime.now.utc.to_date.to_s(:db)} #{(0 if j < 9)}#{j+1}:00:00" }
        end
    end
  end
end
