class Api::V1::BaseController < ApplicationController
  layout "api"
  skip_before_filter :authenticate_user!
end
