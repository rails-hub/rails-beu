class ContactusController < ApplicationController
  # GET /contactus
  # GET /contactus.json
  def index
    @contactus = Contactu.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contactus }
    end
  end

  # GET /contactus/1
  # GET /contactus/1.json
  def show
    @contactu = Contactu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contactu }
    end
  end

  # GET /contactus/new
  # GET /contactus/new.json
  def new
    @contactu = Contactu.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contactu }
    end
  end

  # GET /contactus/1/edit
  def edit
    @contactu = Contactu.find(params[:id])
  end

  # POST /contactus
  # POST /contactus.json
  def create
    @contactu = Contactu.new(params[:contactu])

    respond_to do |format|
      if @contactu.save
        format.html { redirect_to root_path, notice: 'Thanks, We will contact you soon.' }
        format.json { render json: @contactu, status: :created, location: @contactu }
      else
        format.html { render action: "new" }
        format.json { render json: @contactu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contactus/1
  # PUT /contactus/1.json
  def update
    @contactu = Contactu.find(params[:id])

    respond_to do |format|
      if @contactu.update_attributes(params[:contactu])
        format.html { redirect_to @contactu, notice: 'Contactu was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contactu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contactus/1
  # DELETE /contactus/1.json
  def destroy
    @contactu = Contactu.find(params[:id])
    @contactu.destroy

    respond_to do |format|
      format.html { redirect_to contactus_url }
      format.json { head :no_content }
    end
  end
end
