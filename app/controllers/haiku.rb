get '/all' do
  # @haikus = Haiku.joins("LEFT OUTER JOIN likes ON haikus.id = likes.haiku_id").group("haikus.id").order("likes.count DESC").paginate(:page => params[:page])
  @haikus = Haiku.paginate(:page => params[:page], :per_page => 3).order('created_at DESC')
  @title ="All Haikus"
  erb :all
end

get '/haiku/:id' do
  @haiku = Haiku.find(params[:id])
  erb :comments, :locals => {:haiku => @haiku}
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

post "/create_comment/:haiku_id" do
  @haiku = Haiku.find(params[:haiku_id])
  comment = Comment.new( :user_id    => current_user.id,
                            :haiku_id   => @haiku.id,
                            :line_1     => params[:line_1],
                            :line_2     => params[:line_2],
                            :line_3     => params[:line_3])
  if comment.save
    redirect to "/haiku/#{@haiku.id}"
  else
    @errors = "Not a valid haiku"
    erb :comments, :locals => {:haiku => @haiku}
  end
end

get "/recent_comments" do
  @comments = Comment.order("created_at DESC").limit(5)
  erb :recent_comments
end