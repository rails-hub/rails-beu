class TempImagesController < ApplicationController
  # GET /temp_images
  # GET /temp_images.json
  def index
    @temp_images = TempImage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @temp_images }
    end
  end

  # GET /temp_images/1
  # GET /temp_images/1.json
  def show
    @temp_image = TempImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @temp_image }
    end
  end

  # GET /temp_images/new
  # GET /temp_images/new.json
  def new
    @temp_image = TempImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @temp_image }
    end
  end

  # GET /temp_images/1/edit
  def edit
    @temp_image = TempImage.find(params[:id])
  end

 
  
  def not_image?
    params[:not_image].blank? and params[:not_image]== false
  end
  
  def set_form
    session[:back_img_color] = params[:temp_image][:back_img_color] if params[:temp_image][:back_img_color].present?
    session[:back_color] = params[:temp_image][:back_color] if params[:temp_image][:back_color].present?
# session[:back_img_color] = session[:back_color] = ''
  end


  # POST /temp_images
  # POST /temp_images.json
  def create
    
    params[:temp_image] ||={}
    params[:temp_image].merge!({params[:column_name] => params[:column_value], :session_id => session[:session_id]}) if params[:column_name].present? and params[:column_value].present?
    set_form
    puts "-----params[:temp_image]===#{params[:temp_image].inspect}"
    @temp_image = TempImage.find_by_session_id(params[:temp_image][:session_id])
#    puts "@temp_image==#{@temp_image.inspect}"
    if @temp_image.present?

      respond_to do |format|
        if @temp_image.update_attributes(params[:temp_image])
          
          flash[:notice] = 'Image successfully uploaded' if not_image?
          format.js {render json: {:success => true, :status_code => 200, :message => "Image Saved"}}
          format.html { redirect_to :back}
          format.json { render json: @temp_image, status: :created, location: @temp_image }
        else
          
#          flash[:error] = 'Image not uploaded (only jpeg/png/gif images)' if not_image?
          flash[:error] = @temp_image.errors.first[1].capitalize #if flash[:error].blank?
          format.js{render json: {:success => false, :status_code => 400, :message => "Unable to save image"}}
#          format.json {render :text=> 'ok'}
          format.html { redirect_to :back, :error=> 'Unable to save Image'}
          format.json { render json: @temp_image.errors, status: :unprocessable_entity }
        end
      end
    else
      @temp_image = TempImage.new(params[:temp_image])
     
      respond_to do |format|
        if @temp_image.save
          
          flash[:notice] = 'Image successfully uploaded' if not_image?
          format.js{render json: {:success => true, :status_code => 200, :message => "Image Saved"}}
          format.html { redirect_to :back}
  #        format.html { redirect_to @temp_image, notice: 'Temp image was successfully created.' }
          format.json { render json: @temp_image, status: :created, location: @temp_image }
        else
          flash[:error] = 'Image not uploaded' if not_image?
          format.js{render json: {:success => false, :status_code => 404, :message => "Unable to save image"}}
          format.html { redirect_to :back, :error=> 'Unable to save Image'}
          format.json { render json: @temp_image.errors, status: :unprocessable_entity }
        end
      end
    end
    
  end




  # PUT /temp_images/1
  # PUT /temp_images/1.json
  def update
    @temp_image = TempImage.find(params[:id])

    respond_to do |format|
      if @temp_image.update_attributes(params[:temp_image])
        format.html { redirect_to @temp_image, notice: 'Temp image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @temp_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /temp_images/1
  # DELETE /temp_images/1.json
  def destroy
    @temp_image = TempImage.find(params[:id])
    @temp_image.destroy

    respond_to do |format|
      format.html { redirect_to temp_images_url }
      format.json { head :no_content }
    end
  end
end
