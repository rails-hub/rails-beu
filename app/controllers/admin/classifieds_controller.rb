class Admin::ClassifiedsController < ApplicationController
  # GET /admin/classifieds
  # GET /admin/classifieds.json
  def index
    @admin_classifieds = Admin::Classified.all
    @admin_classified = Admin::Classified.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_classifieds }
    end
  end

  # GET /admin/classifieds/1
  # GET /admin/classifieds/1.json
  def show
    @admin_classifieds = Admin::Classified.all
    @admin_classified = Admin::Classified.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_classified }
    end
  end

  # GET /admin/classifieds/new
  # GET /admin/classifieds/new.json
  def new
    @admin_classifieds = Admin::Classified.all
    @admin_classified = Admin::Classified.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_classified }
    end
  end

  # GET /admin/classifieds/1/edit
  def edit
    @admin_classifieds = Admin::Classified.all
    @admin_classified = Admin::Classified.find(params[:id])
  end

  # POST /admin/classifieds
  # POST /admin/classifieds.json
  def create
    @admin_classifieds = Admin::Classified.all
    @admin_classified = Admin::Classified.new(params[:admin_classified])

    respond_to do |format|
      if @admin_classified.save
        flash[:notice] = 'Classified was successfully created.'
        format.html { redirect_to admin_classifieds_path, notice: 'Classified was successfully created.' }
        format.json { render json: @admin_classified, status: :created, location: @admin_classified }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_classified.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/classifieds/1
  # PUT /admin/classifieds/1.json
  def update
    @admin_classifieds = Admin::Classified.all
    @admin_classified = Admin::Classified.find(params[:id])

    respond_to do |format|
      if @admin_classified.update_attributes(params[:admin_classified])
        flash[:notice] = 'Classified was successfully updated.'
        format.html { redirect_to admin_classifieds_path, notice: 'Classified was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_classified.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/classifieds/1
  # DELETE /admin/classifieds/1.json
  def destroy
    @admin_classifieds = Admin::Classified.all
    @admin_classified = Admin::Classified.find(params[:id])
    @admin_classified.destroy
    flash[:notice] = 'Classified was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to admin_classifieds_url }
      format.json { head :no_content }
    end
  end
end
