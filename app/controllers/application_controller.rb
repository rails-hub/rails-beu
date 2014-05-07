class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :params_checker
  before_filter :domain_url
  before_filter :session_cookies_remove

  def session_cookies_remove
#    puts "in remove-----------------------session_cookies_remove"
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

  def params_checker
#    puts "params.inspect=====#{params.inspect}"
#    puts "session.inspect=====#{session.inspect}"
  end
  
  def domain_url
#    request.env[:HTTP_REFERER]
   $domain =  if Rails.env.production?
      'beu-staging.herokuapp.com'
#      'http://beu.herokuapp.com'
    else
      'http://localhost:3000'
    end
#    puts "$domain$domain$domain$domain=====#{$domain}====request.session_options[:id]#{request.session_options[:id]}"
  end

  module SharedUser
    def get_tmp_user
     @tmp_user = TempUser.find_by_session_id(session[:session_id])
     @tmp_user = TempUser.create(:session_id => session[:session_id]) if @tmp_user.nil?
    end


  end

  module SharedCoupen
    def get_tmp_coupen
       #      @tmp_img = TempImage.find_by_session_id(request.session_options[:id])
       #      @tmp_img = TempImage.create(:session_id => request.session_options[:id]) if @tmp_img.nil?
      @tmp_img = TempImage.find_by_session_id(session[:session_id])
      @tmp_img = TempImage.create(:session_id => session[:session_id]) if @tmp_img.nil?

      @deal_wizard =  if session[:deals_wizard].present?
        DealsWizard.new(session[:deals_wizard])
        elsif @deal.present?
          @deal.deals_wizard
      end
    end
  end

#  #api related functions
    def checkTokenKeyParam
    if (params[:token_key].nil?)
      respond_to do |format|
        format.json {render json:{:success => false, :status_code => 400, :message => "Token Key parameter not found or invalid Token Key"}}
        format.xml {render xml:{:success => false, :status_code => 400, :message => "Token Key parameter not found or invalid Token Key"}}
        format.html {render json: {:success => false, :status_code => 400, :message => "Token Key parameter not found or invalid Token Key"}}
      end
    else
      return true
    end
  end

  def validateTokenKey
    user = User.find_by_token_key(params[:token_key])
    if user.nil?
      respond_to do |format|
        format.json {render json:{:success => false, :status_code => 400, :message => "Invalid token key"}}
        format.xml {render xml:{:success => false, :status_code => 400, :message => "Invalid token key"}}
        format.html {render json: {:success => false, :status_code => 400, :message => "Invalid token key"}}
      end
    else
      return true
    end
  end

  def getUserByTokenKey
    @user = User.find_by_token_key (params[:token_key])
  end

  def getUserGenderByTokenKey
    user = User.find_by_token_key(params[:token_key])
    if user.nil?
      return nil
    else
      return user.gender
#      return (user.gender=="male" || user.gender=="Male") ? true : false
    end
  end

  def getUserAgeByTokenKey
    user = User.find_by_token_key(params[:token_key])
    if user.nil? || user.dob.nil? || user.dob == ''
      return 0
    else
      return self.extractAgeFromBirthDay(user.dob)
    end
  end

  def extractAgeFromBirthDay(birth_day)
    age = Time.zone.now - birth_day
    return (age / 31557600).round()
  end
  
end
