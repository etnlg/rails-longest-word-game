require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = ('a'..'z').to_a.shuffle[0,10]
  end

  def score
    @word = params[:word]
    @letter_array = @word.chars
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = URI.open(url).read
    hash = JSON.parse(user_serialized)
    @letters = params['letter']
    @condition = @letter_array.all? {|letter| @letters.include?(letter) && @letter_array.count(letter) <= @letters.count(letter) }
    if hash["found"] && @condition
      @response = "Congrats, you won the game pal"
      @score = @word.length**2
      @response += "with a score of #{@score}"
    elsif @condition == false
      @response = "Sorry, but #{@word} can't be built out of #{@letters}"
      @score = 0
    else
      @response = "Sorry, but #{@word} is not an english word"
      @score = 0
    end
    if session[:grand_score].nil?
      session[:grand_score] = [@score]
    else
      session[:grand_score].push(@score)
    end
    @session_array = session[:grand_score]
    @grand = @session_array.sum
  end

end
