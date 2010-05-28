# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :authenticate


  # FIXME: should be digest auth
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      unless (request.headers['HTTP_USER_AGENT'] == 'ParserHTTPRequest' and
            request.format == 'application/xml' )
        redirect_to '/'
      end

      if session[:user_id]
        @current_user = User.find(session[:user_id])
      else
        @current_user = User.find_by_device(username) || begin
          @current_user = User.new(:device => username)
          @current_user.save
          @current_user
        end
        session[:user_id] = @current_user.id
      end
      #response.headers["User-Id"] = @current_user.id.to_s
      #logger.warn response.headers
    end
    #logger.warn @current_user.try(:device)
  end

  # http://ryandaigle.com/articles/2009/1/30/what-s-new-in-edge-rails-http-digest-authentication
  def digest_authenticate
    # Given this username, return the cleartext password (or nil if not found)
    honk = authenticate_or_request_with_http_digest do |username|
      User.find_by_device(username).try(:device)
    end
  end

end
