class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.xml
  def index
    if (params[:m] and !(except_ids = params[:m].keys.collect { |id| id.to_i }).empty? )
      @messages = Message.find(:all,
        :conditions => [
          "created_at > ? and id not in (?) and (user_id = ? or in_reply_to_user_id = ?)",
          Time.now.months_ago(1),
          except_ids,
          @current_user.id,
          @current_user.id
        ])
    else
      @messages = Message.find(:all,
        :conditions => [
          "created_at > ? and (user_id = ? or in_reply_to_user_id = ?)",
          Time.now.months_ago(1),
          @current_user.id,
          @current_user.id
        ])
    end

    respond_to do |format|
      format.xml  {
        #proc = Proc.new { |options| options[:builder].tag!('created_at', 'def') }
        render :text => @messages.to_xml(:skip_types => true)
      }
    end
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    @message.user = @current_user

    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully created.'

        if apn_device = @message.post.user.apn_device
          notification = APN::Notification.new
          notification.device = apn_device
          notification.alert = "you have a new message"
          notification.save
        end

        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

end
