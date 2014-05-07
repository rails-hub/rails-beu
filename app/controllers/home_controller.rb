class HomeController < ApplicationController
  
  before_filter :authenticate_user!
  
  def actions
    #to display main screen of actions
  end
end
