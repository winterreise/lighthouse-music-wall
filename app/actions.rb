# User auth
get '/signup' do
  erb :'auth/signup'
end

post '/users' do
  @user = User.new(
    email: params[:email],
    password:  params[:password]
  )
  if @user.save
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
      # TODO session schtuff
      redirect :'/tracks'
    end
  end
end

get '/logout' do
  # TODO
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
  @track = Track.new
  erb :'tracks/new'
end

get '/tracks/:id' do
  @track = Track.find params[:id]
  erb :'tracks/show'
end

post '/tracks' do
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
end
