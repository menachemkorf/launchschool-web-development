require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"
require "yaml"

helpers do
  def count_interests(users)
    users.reduce(0) do |sum, (_name, user)|
      sum + user[:interests].length
    end
  end
end

before do
  @users = YAML.load_file('users.yaml')
end

get "/" do
  erb :home
end

get "/users/:name" do
  user = params[:name].to_sym
  @user_info = @users[user]
  erb :user
end

not_found do
  redirect "/"
end
