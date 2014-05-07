class DealsWizardsController < ApplicationController
  # GET /deals_wizards
  # GET /deals_wizards.json
  before_filter :set_compaign_objectives, :only => [:new, :create]
  before_filter :set_required_data, :only => [:compaign_objectives]
  before_filter :get_selected_objectives, :only => [:set_deal_wizard]
  after_filter :remove_session_data, :only => [:create]
  skip_before_filter :session_cookies_remove
  def index
    @deals_wizards = DealsWizard.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @deals_wizards }
    end
  end

  # GET /deals_wizards/1
  # GET /deals_wizards/1.json
  def show
    @deals_wizard = DealsWizard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deals_wizard }
    end
  end

  def compaign_objectives
#   # @compaign_objectives = CompaignObjective.all
      campaign_objectives
   
  end



  def set_deal_wizard
    @deals_wizard = DealsWizard.new(session[:deals_wizard])
  end


  def send_data
    compaign_obj = params[:compaign_objectives_id]
    session[:compaign_objectives_id] = compaign_obj
    session[compaign_obj.to_sym] = params[compaign_obj.to_sym] if compaign_obj.present?
    
    session[:deals_wizard] = params[:deals_wizard] if params[:deals_wizard].present?
    
    respond_to do |format|
      if params[:deal_id].present?
        format.html { redirect_to edit_deal_path(:id => params[:deal_id]) }
      else
        format.html { redirect_to new_deal_path }
      end
    end
    
  end
  # GET /deals_wizards/new
  # GET /deals_wizards/new.json
  def new
    @deals_wizard = DealsWizard.new
  
    
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @deals_wizard }
    end
  end

  # GET /deals_wizards/1/edit
  def edit
    @deals_wizard = DealsWizard.find(params[:id])
  end

  # POST /deals_wizards
  # POST /deals_wizards.json
  def create
    @deals_wizard = DealsWizard.new(params[:deals_wizard])
 
    respond_to do |format|
      if @deals_wizard.save
        format.html { redirect_to edit_deal_path(:id => params[:deals_wizard][:deal_id]) , notice: 'Deal was successfully created.' }
#        format.html { redirect_to @deals_wizard, notice: 'Deals wizard was successfully created.' }
        format.json { render json: @deals_wizard, status: :created, location: @deals_wizard }
      else
        format.html { render action: "new" }
        format.json { render json: @deals_wizard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /deals_wizards/1
  # PUT /deals_wizards/1.json
  def update
    @deals_wizard = DealsWizard.find(params[:id])

    respond_to do |format|
      if @deals_wizard.update_attributes(params[:deals_wizard])
        format.html { redirect_to @deals_wizard, notice: 'Deals wizard was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deals_wizard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deals_wizards/1
  # DELETE /deals_wizards/1.json
  def destroy
    @deals_wizard = DealsWizard.find(params[:id])
    @deals_wizard.destroy

    respond_to do |format|
      format.html { redirect_to deals_wizards_url }
      format.json { head :no_content }
    end
  end

  def set_compaign_objectives
   
#    session[:compaign_objectives] = params[:compaign_objectives] if params[:compaign_objectives].present?
#    @compaign_objectives_ids = session[:compaign_objectives].keys if session[:compaign_objectives].present?
#    @compaign_objectives_ids = params[:compaign_objectives].keys if params[:compaign_objectives].present?
#
#    @comaign_obj_ids = @compaign_objectives_ids.join(',') if @compaign_objectives_ids.present?
#    @compaign_objectives = CompaignObjective.find_all_by_id(@compaign_objectives_ids)

  end
  
  def remove_session_data
#    session.delete(:compaign_objectives)
#    session.delete(:deal_id)

  end
  
  def set_required_data
     session[:deal_id] = params[:deal_id] if params[:deal_id].present?
#     session[:deal] = {:title => cookies[:deal_title], :bold => cookies[:deal_bold],
#       :bold => cookies[:deal_italic] , :bold => cookies[:deal_underline], :bold => cookies[:deal_font_name],
#       :bold => cookies[:deal_font_color], :bold => cookies[:deal_font_size], :bold => cookies[:deal_description],
#       }
  end

  def campaign_objectives
     @compaign_objectives = {
        1 => "Increase Volume or Revenue Dollars per Sales Transaction",
        2=> "Increase Customer Traffic to your Business",
        3 => "Increase Sales of a Particular Item or Turnover Slower Moving Items",
        4 => "Reward or Entice Past Customers to Make a New Purchase",
        5 => "Last Minute Sales of Perishable or Time Sensitive Items/Services"
        }
  end
  
  def get_selected_objectives

      campaign_objectives
      @compaign_objectives_id = ''
      @selected_objective = ''
      @compaign_objectives_id = params[:compaign_objectives].present? ? params[:compaign_objectives].to_i  : 1
      @selected_objective= @compaign_objectives[@compaign_objectives_id]
  end

end
