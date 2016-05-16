# Homepage (Root path)
get '/' do
  erb :index
end

get '/tracks' do
  erb :'tracks/index'
end
