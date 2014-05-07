class Admin::BasesController < ApplicationController
 layout 'admin'
 skip_before_filter :authenticate_user!
end
