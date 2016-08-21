require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"
require "yaml"

require 'pry'

helpers do
  def count_interests(users)
    interests = []
    users.each do |name, info|
      interests << info[:interests]
    end
    interests.flatten.count
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