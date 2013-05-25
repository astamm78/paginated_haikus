get '/narwhal' do
  erb :signin
end

post '/verify' do
  @login_auth = User.authenticate(params[:email], params[:password])
  if @login_auth == true
    session[:user_id] = User.find_by_email(params[:email]).id
    redirect to "/create"
  else
    @errors = "Please log in with a valid email and password"
    erb :signin
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect to '/'
end

get '/platypus' do
  if @login_auth == true
    redirect to '/rand'
  else
    erb :signup
  end
end

post '/create_account' do
  @new_user = User.create(  :full_name  => params[:full_name],
                            :email      => params[:email],
                            :password   => params[:password])
  if @new_user.save
    session[:user_id] = @new_user.id
    redirect to "/author/#{@new_user.id}"
  else
    @errors = "Full Name, a valid email and a password<br>of at least 5 characters are required"
    erb :signup
  end
end