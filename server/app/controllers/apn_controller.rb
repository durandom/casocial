class ApnController < ApplicationController
  def create
    token = params[:token][1..-2] # chop < and > at the end
    unless device = APN::Device.find_by_token(token)
      device = APN::Device.create(:token => token)
      @current_user.apn_device = device
      @current_user.save
    end

    render :nothing => true

  end
end
