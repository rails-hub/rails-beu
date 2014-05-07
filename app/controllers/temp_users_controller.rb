class TempUsersController < ApplicationController
  skip_before_filter :require_no_authentication
   before_filter :authenticate_user!

   def create
   
   
    puts "params[:temp_user]===#{params[:temp_user].inspect}"
    @temp_user = TempUser.find_by_session_id(params[:temp_user][:session_id])
    puts "@temp_user==#{@temp_user.inspect}"
    if @temp_user.present?

      respond_to do |format|
        if @temp_user.update_attributes(params[:temp_user])

          flash[:notice] = 'Image successfully uploaded' unless request.xhr?
          format.js
          format.html { redirect_to :back}
          format.json { render json: @temp_user, status: :created, location: @temp_user }
        else

          flash[:error] = @temp_user.errors.first[1].capitalize #if flash[:error].blank?
          format.js{render json: {:success => false, :status_code => 400, :message => "Unable to save image"}}
          format.html { redirect_to :back, :error=> 'Unable to save Image'}
          format.json { render json: @temp_user.errors, status: :unprocessable_entity }
        end
      end
    else
      @temp_user = TempImage.new(params[:temp_user])

      respond_to do |format|
        if @temp_user.save

          flash[:notice] = 'Image successfully uploaded' 
          format.js{render json: {:success => true, :status_code => 200, :message => "Image Saved"}}
          format.html { redirect_to :back}
          format.json { render json: @temp_user, status: :created, location: @temp_user }
        else
          flash[:error] = 'Image not uploaded' 
          format.js{render json: {:success => false, :status_code => 400, :message => "Unable to save image"}}
          format.html { redirect_to :back, :error=> 'Unable to save Image'}
          format.json { render json: @temp_user.errors, status: :unprocessable_entity }
        end
      end
    end

  end



end
