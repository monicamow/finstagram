helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
  @posts = Post.order(created_at: :desc)
  erb(:index)
end

get '/welcome' do
  send_file 'app/views/welcome.html'
end

get '/signup' do # if a user navigates to the path "/signup"
  @user = User.new # setup empty @user object
  erb(:signup) # render "app/views/signup.erb"
end

post '/signup' do
  
    # grab user input values from params
    email = params[:email]
    avatar_url = params[:avatar_url]
    username = params[:username]
    password = params[:password]
    
    # instantiate a user
    @user = User.new({email: email, avatar_url: avatar_url, username: username, password: password})
    
    # if user validations pass and user is saved
    if @user.save
  
      # redirect to login page
      redirect(to('/login'))
    
    else
      
      # return to signup and display simple error message
      erb(:signup)
  end
  
end

get '/login' do # when a GET request comes into /login
	erb(:login) # render app/views/login.erb
end

post '/login' do # when we submit a form with an action of /login
  username = params[:username]
  password = params[:password]

  #1. find user by username
  user = User.find_by(username: username)
  
  #2. if that user exists and that user's password mathces the password input
    if user && user.password == password
      #login
      session[:user_id] = user.id
      redirect(to('/'))
    else
    @error_message = "Login failed."
    erb(:login)
    end
end

get '/logout' do # why not post?
  session[:user_id] = nil
  redirect(to('/welcome'))
end

get '/posts/new' do
  
  @post = Post.new
  erb(:"posts/new")
  
end

post '/posts' do
  photo_url = params[:photo_url]
  
  # instantiate new Post
  @post = Post.new({photo_url: photo_url, user_id: current_user.id})
  
  # if @post validates, save
  if @post.save
    redirect(to('/'))
  else
    # if it does not validate, print error messages and go back to posts/new
    erb(:"posts/new")
  end
end

get '/posts/:id' do
  @post = Post.find(params[:id]) # find the post with the ID from the URL
  erb(:"posts/show") # render app/views/posts/show.erb
end

post '/comments' do
  
  # point values from params to variables
  text = params[:text]
  post_id = params[:post_id]
  
  # instantiate a comment with those values and assign the comment to the current_user
  comment = Comment.new({text: text, post_id: post_id, user_id: current_user.id})
  
  # save the comment
  comment.save
  
  # redirect back to wherever we came from -- post '/posts/[:post_id]' or the feed '/'
  redirect(back)

end

post '/likes' do
  
  # point values from params to variables
  post_id = params[:post_id]
  
  # instantiate a comment with those values and assign the comment to the current_user
  like = Like.new({post_id: post_id, user_id: current_user.id})
  
  # save the comment
  like.save
  
  # redirect back to wherever we came from -- post '/posts/[:post_id]' or the feed '/'
  redirect(back)

end

delete '/likes/:id' do
  like = Like.find(params[:id])
  like.destroy
  redirect(back)
end

# @post_starbucks = Post.joins(:user).find_by(users: { username: 'starbucks_lover'})

# @post_starbucks = Post.joins(:user).find_by(users: { username: 'donut_lover'})

# @post_starbucks = Post.joins(:user).find_by(users: { username: 'robot_lover'})
  
# @posts = [@post_starbucks, @post_donut, @post_robot]
 

 