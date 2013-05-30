get '/all' do
  @haikus = Haiku.joins("LEFT OUTER JOIN likes ON haikus.id = likes.haiku_id").group("haikus.id").order("likes.count DESC").paginate(:page => params[:page])
  @title ="All Haikus"
  erb :all
end

get '/haiku/:id' do
  @haiku = Haiku.find(params[:id])
  erb :haiku
end

get '/like/:id' do
  if Like.where(:haiku_id => params[:id], :user_id => current_user.id).length == 0
    Like.create(:user_id => current_user.id, :haiku_id => params[:id])
  end
  redirect "/user/#{current_user.id}"
end

get '/newest' do
  @haiku = Haiku.order(:created_at).reverse.first
  erb :haiku, :locals => {:haiku => @haiku}
end
