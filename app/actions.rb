# with help from http://stackoverflow.com/questions/3559824/what-is-a-very-simple-authentication-scheme-for-sinatra-rack

set :sessions => true

# give all endpoints access to @user, if there is one
before do
  @user = User.find(session[:user_id]) if session[:user_id]
end

# User auth
get '/signup' do
  erb :'auth/signup'
  #TODO password match check
end

post '/users' do
  @user = User.new(
    email: params[:email],
    password:  params[:password]
  )
  if @user.save
    @user.reload
    session[:user_id] = @user.id # store the user id in the session
    redirect '/tracks'
  else
    erb :'auth/signup'
  end
end

get '/login' do
  @email = ''
  erb :'auth/login'
end

post '/login' do
  @email = params[:email]
  # did the user give us what we asked for?
  if params[:email].empty? or params[:password].empty?
    @error = 'Whoops! Email and password must not be blank.'
    erb :'auth/login'
  else
    # TODO check to see if user exists and password matches
    @user = User.where(email: params[:email], password: params[:password]).first
    if @user == nil
      # then we didn't find one that matched! So their password must be wrong or they don't exist
      @error = 'Whoops! Your password is wrong or we couldn\'t find you.'
      erb :'auth/login'
    else
      # log them in since we found a matching user
      session[:user_id] = @user.id # store the user id in the session
      redirect :'/tracks'
    end
  end
end

get '/logout' do
  session.clear
  redirect :'/tracks'
end

# Homepage (Root path)
get '/' do
  erb :index
end

get '/tracks' do
  @tracks = Track.all
  erb :'tracks/index'
end

get '/tracks/new' do
  if @user
    @track = Track.new
    erb :'tracks/new'
  else
    redirect :'/login'
  end
end

get '/tracks/:id' do
  @track = Track.find params[:id]
  @reviews = Review.where(track: @track).order(created_at: :desc)
  @my_review = Review.where(user: @user, track: @track).first
  erb :'tracks/show'
end

post '/tracks' do
  if @user
    @track = Track.new(
      title: params[:title],
      author:  params[:author],
      url: params[:url]
    )
    if @track.save
      redirect '/tracks'
    else
      erb :'tracks/new'
    end
  else
    redirect :'/login'
  end
end

post '/tracks/:track_id/reviews' do
  if @user
    @track = Track.find(params[:track_id])
    @review = Review.new(
      user: @user,
      track: @track,
      title: params[:title],
      content: params[:content],
      rating: params[:rating]
    )
    if @review.save
      redirect "/tracks/#{params[:track_id]}"
    else
      @reviews = Review.where(track: @track).order(created_at: :desc)
      @my_review = Review.where(user: @user, track: @track).first
      erb :'tracks/show'
    end
  else
    redirect :'/login'
  end
end

delete '/tracks/:track_id/reviews' do
  if @user
    @track = Track.find(params[:track_id])
    @my_review = Review.where(user: @user, track: @track).first
    Review.destroy(@my_review.id) if @my_review
    redirect "/tracks/#{params[:track_id]}"
  else
    redirect :'/login'
  end
end
