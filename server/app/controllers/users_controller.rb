class UsersController < ApplicationController

  # shows current logged in user
  def index
    respond_to do |format|
      format.xml  { render :xml => @current_user }
    end
  end

end
