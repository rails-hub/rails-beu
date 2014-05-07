class TargetRulesController < ApplicationController

  include SharedCoupen
  skip_before_filter :session_cookies_remove

  
   # GET /target_rules
  # GET /target_rules.json
  def index
    @target_rules = TargetRule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @target_rules }
    end
  end

  # GET /target_rules/1
  # GET /target_rules/1.json
  def show
    @target_rule = TargetRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @target_rule }
    end
  end

  # GET /target_rules/new
  # GET /target_rules/new.json
  def new
    @target_rule = TargetRule.new(params[:target_rule])
#    @deal = Deal.find_by_id(params[:target_rule][:deal_id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @target_rule }
    end
  end

  # GET /target_rules/parameter_setup
  # GET /target_rules/parameter_setup.json
  def parameter_setup


    if params[:deal_id].present?
      @deal = Deal.find_by_id(params[:deal_id])
      @target_rule = @deal.target_rule.present? ? @deal.target_rule : TargetRule.new
    else
      @target_rule = TargetRule.new
    end

    respond_to do |format|
      format.html # parameter_setup.html.erb
      format.json { render json: @target_rule }
    end
  end

  
  
  def show_params
    
    session[:target_rule] = params[:target_rule] if params[:target_rule].present?
    
    get_tmp_coupen
    @target_rule = TargetRule.new(params[:target_rule])
    
    if @target_rule.stoday=="1"
      if Time.zone.now >= @target_rule.end_date
        #redirect_to :back
        flash[:error] = 'End Date should be greater than Start Date'
        render :parameter_setup
      end
    elsif params[:deal_id].blank? and @target_rule.start_date.strftime('%d %m %y') <  Date.today.strftime('%d %m %y')
      #redirect_to :back
        flash[:error] = "Date should be greater than Today's date"
       render :parameter_setup
    elsif  @target_rule.start_date >= @target_rule.end_date
      #redirect_to :back
      flash[:error] = 'End Date should be greater than Start Date'
       render :parameter_setup
    end
    @deal =   params[:deal_id].present?  ? Deal.find_by_id(params[:deal_id]) : Deal.new(session[:deal])
    
  end


  
def set_date_format(p,date1)
  return DateTime.new(p["#{date1}(1i)"].to_i,
                        p["#{date1}(2i)"].to_i,
                        p["#{date1}(3i)"].to_i,
                        p["#{date1}(4i)"].to_i,
                        p["#{date1}(5i)"].to_i)
                      
end
  # GET /target_rules/1/edit
  def edit
    @target_rule = TargetRule.find(params[:id])
  end

  # POST /target_rules
  # POST /target_rules.json
  def create
    @target_rule = TargetRule.new(params[:target_rule])

    respond_to do |format|
      if @target_rule.save
        format.html { redirect_to new_target_rule_path, notice: 'Compaign Params was successfully created.' }
#        format.html { redirect_to @target_rule, notice: 'Compaign Params was successfully created.' }
        format.json { render json: @target_rule, status: :created, location: @target_rule }
      else
        format.html { render action: "new" }
        format.json { render json: @target_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /target_rules/1
  # PUT /target_rules/1.json
  def update
    @target_rule = TargetRule.find(params[:id])

    respond_to do |format|
      if @target_rule.update_attributes(params[:target_rule])
        format.html { redirect_to @target_rule, notice: 'Target rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @target_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /target_rules/1
  # DELETE /target_rules/1.json
  def destroy
    @target_rule = TargetRule.find(params[:id])
    @target_rule.destroy

    respond_to do |format|
      format.html { redirect_to target_rules_url }
      format.json { head :no_content }
    end
  end
end
