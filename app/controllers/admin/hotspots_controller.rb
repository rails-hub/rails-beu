class Admin::HotspotsController < ApplicationController
  # GET /admin/hotspots
  # GET /admin/hotspots.json
  def index    
    @admin_hotspots = Admin::Hotspot.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_hotspots }
    end
  end

  # GET /admin/hotspots/1
  # GET /admin/hotspots/1.json
  def show
    @admin_hotspot = Admin::Hotspot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_hotspot }
    end
  end

  # GET /admin/hotspots/new
  # GET /admin/hotspots/new.json
  def new
    @admin_hotspot = Admin::Hotspot.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_hotspot }
    end
  end

  # GET /admin/hotspots/1/edit
  def edit
    @admin_hotspot = Admin::Hotspot.find(params[:id])
  end

  # POST /admin/hotspots
  # POST /admin/hotspots.json
  def create
    @admin_hotspot = Admin::Hotspot.new(params[:admin_hotspot])

    respond_to do |format|
      if @admin_hotspot.save
        format.html { redirect_to admin_hotspots_path, notice: 'Hotspot was successfully created.' }
        format.json { render json: @admin_hotspot, status: :created, location: @admin_hotspot }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_hotspot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/hotspots/1
  # PUT /admin/hotspots/1.json
  def update
    message=''
    @admin_hotspot = Admin::Hotspot.find(params[:id])
    if params[:admin_hotspot][:called_by]=='unlink'
        message='Hotspot was successfully unlinked.' 
    elsif 
        params[:admin_hotspot][:called_by]=='link'
        message='Hotspot was successfully linked.'
     end
      if  params[:admin_hotspot][:called_by]=='update'
        message='Hotspot information was successfully updated.'
    end
    respond_to do |format|
      params[:admin_hotspot].merge!(:zone_id=>params[:admin_hotspot][:zone_id]) if params[:admin_hotspot][:zone_id].present? and params[:admin_hotspot].present?
      if @admin_hotspot.update_attributes(params[:admin_hotspot])
        if params[:admin_hotspot][:called_by]=='update' 
        format.html { redirect_to admin_hotspots_path, notice: message }
        else
            format.html { redirect_to admin_zones_path, notice: message }
        end
                format.json { head :no_content }
      else
        #format.html { render action: "edit" }
        format.html { redirect_to edit_admin_zone }
        format.json { render json: @admin_hotspot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/hotspots/1
  # DELETE /admin/hotspots/1.json
  def destroy
    @admin_hotspot = Admin::Hotspot.find(params[:id])
    @admin_hotspot.destroy

    flash[:notice] = 'Hotspot was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to admin_hotspots_url }
      format.json { head :no_content }
    end
  end
end
