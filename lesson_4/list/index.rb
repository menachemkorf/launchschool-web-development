require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

require 'pry'

get "/" do
  @files = Dir.glob("public/*.*").map { |file| File.basename(file) }.sort
  @files.reverse! if params[:sort] == "desc"
  erb :list
end