class Api::V1::TargetRulesController < Api::V1::BaseController
  # GET /api/v1/target_rules
  # GET /api/v1/target_rules.json
  def index
    @api_v1_target_rules = TargetRule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @api_v1_target_rules }
    end
  end

  # GET /api/v1/target_rules/1
  # GET /api/v1/target_rules/1.json
  def show
    @api_v1_target_rule = TargetRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @api_v1_target_rule }
    end
  end

  # GET /api/v1/target_rules/new
  # GET /api/v1/target_rules/new.json
  def new
    @api_v1_target_rule = TargetRule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @api_v1_target_rule }
    end
  end

  # GET /api/v1/target_rules/1/edit
  def edit
    @api_v1_target_rule = TargetRule.find(params[:id])
  end

  # POST /api/v1/target_rules
  # POST /api/v1/target_rules.json
  def create
    @api_v1_target_rule = TargetRule.new(params[:target_rule])

    respond_to do |format|
      if @api_v1_target_rule.save
        format.html { redirect_to api_v1_target_rules_path, notice: 'Target rule was successfully created.' }
        format.json { render json: @api_v1_target_rule, status: :created, location: @api_v1_target_rule }
      else
        format.html { render action: "new" }
        format.json { render json: @api_v1_target_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api/v1/target_rules/1
  # PUT /api/v1/target_rules/1.json
  def update
    @api_v1_target_rule = TargetRule.find(params[:id])

    respond_to do |format|
      if @api_v1_target_rule.update_attributes(params[:target_rule])
        format.html { redirect_to api_v1_target_rules_path, notice: 'Target rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @api_v1_target_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v1/target_rules/1
  # DELETE /api/v1/target_rules/1.json
  def destroy
    @api_v1_target_rule = TargetRule.find(params[:id])
    @api_v1_target_rule.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_target_rules_url }
      format.json { head :no_content }
    end
  end
end
