require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

require 'pry'

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end
end

def each_chapter(&block)
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapters_matching(query)
  # chapters = Dir.glob("data/chp*.txt").map { |file| File.read(file)}
  results = []

  return results unless query

  each_chapter do |number, name, contents|
    results << {number: number, name: name} if contents.include?(query)
  end
  results
end

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  @title = "Chapter #{number}: #{@contents[number - 1]}"
  @chapter = File.read "data/chp#{number}.txt"
  erb :chapter
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

not_found do
  redirect "/"
end
