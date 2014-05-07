class CreditCardInformationsController < ApplicationController
  # GET /credit_card_informations
  # GET /credit_card_informations.json
  def index
    @credit_card_informations = CreditCardInformation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @credit_card_informations }
    end
  end

  # GET /credit_card_informations/1
  # GET /credit_card_informations/1.json
  def show
    @credit_card_information = CreditCardInformation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @credit_card_information }
    end
  end

  # GET /credit_card_informations/new
  # GET /credit_card_informations/new.json
  def new
    @credit_card_information = CreditCardInformation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @credit_card_information }
    end
  end

  # GET /credit_card_informations/1/edit
  def edit
    @credit_card_information = CreditCardInformation.find(params[:id])
  end

  # POST /credit_card_informations
  # POST /credit_card_informations.json
  def create
    @credit_card_information = CreditCardInformation.new(params[:credit_card_information])
    split = params[:credit_card_information][:full_name].split(' ')
    respond_to do |format|
      if @credit_card_information.save
        @user = @credit_card_information.user
        @credit_card_information.update_attributes(:first_name => (split[0] if split[0]), :last_name =>( split[1] if split[1]) )
        @credit_card_information = @user.credit_card_informations.where(:is_active=>true).first
        format.html { redirect_to @credit_card_information, notice: 'Credit card information was successfully created.' }
        format.js { render :action=>:update}
        format.json { render json: @credit_card_information, status: :created, location: @credit_card_information }
      else
        format.html { render action: "new" }
        format.json { render json: @credit_card_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /credit_card_informations/1
  # PUT /credit_card_informations/1.json
  def update
    split = params[:credit_card_information][:full_name].split(' ')
    @credit_card_information = CreditCardInformation.find(params[:id])
    @user =  @credit_card_information.user
    respond_to do |format|
      if @credit_card_information.update_attributes(params[:credit_card_information])
        @credit_card_information.update_attributes(:first_name => (split[0] if split[0]), :last_name =>( split[1] if split[1]) )
        format.html { redirect_to @credit_card_information, notice: 'Credit card information was successfully updated.' }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @credit_card_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credit_card_informations/1
  # DELETE /credit_card_informations/1.json
  def destroy
    @credit_card_information = CreditCardInformation.find(params[:id])
    @credit_card_information.destroy

    respond_to do |format|
      format.html { redirect_to credit_card_informations_url }
      format.json { head :no_content }
    end
  end
end
