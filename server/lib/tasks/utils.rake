namespace :utils do
  post_count = ENV['posts'] ? ENV['posts'].to_i : 10
  message_count = ENV['messages'] ? ENV['messages'].to_i : 20
  user_count = ENV['users'] ? ENV['users'].to_i : 3
  require 'webster'
  @webster = Webster.new
  def rsentence(words)
    rv = @webster.random_word.capitalize
    (rand(words)+1).times do
      rv += " " + @webster.random_word
    end
    rv += "."
  end
  def rparagraph(sentences)
    rv = ""
    (rand(sentences)+1).times do
      rv += rsentence(rand(10)+1)
      rv += rand(2)>0 ? " " : "\n"
    end
    rv
  end
  def deg(min, max)
    r = rand ((min - max).abs * 100)
    (format "%0.2f", (r / 100.0) + min).to_f
  end

#  task :deg => :environment do
#    10.times do
#      puts deg(-10, 10)
#    end
#  end

  namespace :post do
    desc "Create Master Post No 1"
    task :master =>  :environment do
      tst = Time.now
      post = Post.new(
        :title => "B4Check",
        :body => "rulez",
        :category => 2,
        :longitude => 90,
        :latitude => 90,
        :accuracy => 0,
        :user_id => 1,
        :serial => tst,
        :created_at => tst,
        :updated_at => tst
      )
      post.id = 1
      post.save
    end

    desc "Destroy all posts"
    task :destroy  => :environment do
      Post.all.each do |p|
        puts "Destroy #{p.id} - #{p.title}"
        p.destroy
      end
    end

    desc "Create #{post_count} random posts (set posts=N)"
    task :create => :environment do
      users = User.all
      post_count.times do
        tst = Time.now - rand(3600 * 24 * 31) # spread over last month
        post = Post.new(
          :title => rsentence(5),
          :body => rparagraph(6),
          :category => rand(3),
          :longitude => deg(-130,-120),
          :latitude => deg(25,40),
          :accuracy => rand(1000),
          :user_id => users.rand.id,
          :serial => tst.to_i,
          :created_at => tst,
          :updated_at => tst
        )
        post.save
      end
    end
  end

  namespace :user do
    desc "Destroy all users"
    task :destroy  => :environment do
      User.all.each do |p|
        puts "Destroy #{p.id} - #{p.device}"
        p.destroy
      end
    end


    desc "Create #{user_count} random users (set users=N)"
    task :create => :environment do
      user_count.times do
        user = User.new(
          :device => @webster.random_word
        )
        user.save
      end
    end
  end


  namespace :message do
    desc "Destroy all messages"
    task :destroy  => :environment do
      Message.all.each do |p|
        puts "Destroy #{p.id} - #{p.body}"
        p.destroy
      end
    end

    desc "Create #{message_count} random messages (set messages=N)"
    task :create => :environment do
      users = User.all
      posts = Post.all
      message_count.times do
        post = posts.rand

        if (post.messages.empty?)
          # New initial message in reply to this post
          user_id = users.rand.id
          in_reply_to_user_id = post.user_id
        else
          if (post.messages.last.user_id == post.user_id)
            # Last message is from original post, create a new message from somebody else
            user_id = users.rand.id
            in_reply_to_user_id = post.user_id
          else
            # Last message is from somebody else, create a reply from the original user
            user_id = post.user_id
            in_reply_to_user_id = post.messages.last.user_id
          end
        end

        tst = post.created_at + rand( Time.now.to_i - post.created_at.to_i )
        message = Message.new(
          :body => rparagraph(6),
          :user_id => user_id,
          :in_reply_to_user_id => in_reply_to_user_id,
          :post_id => post.id,
          :serial => tst.to_i,
          :created_at => tst,
          :updated_at => tst
        )
        message.save
      end
    end
  end
end
