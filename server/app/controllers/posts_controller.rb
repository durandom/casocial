class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
  def index
    opts = {
      :page => params[:pg] || 1,
      :origin => [params[:lat] || 0.0 ,params[:lgn] || 0.0],
      :order => 'distance',
      :conditions => ['created_at > ?', Time.now.months_ago(1)]
      }

    if (params[:p] and !(except_ids = params[:p].keys.collect { |id| id.to_i }).empty? )
      opts[:conditions][0] += " and id not in (?)"
      opts[:conditions] << except_ids
    end

    # add distance filter
    if (params[:d])
      opts[:within] = params[:d].to_i / 1000;
    end

    @posts = Post.paginate(opts)

    respond_to do |format|
      format.xml  { render :xml => @posts }
    end
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    @post.user = @current_user

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

end
