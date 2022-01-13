require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @proposed_letters = params[:letters]
    if parsing(@word)['found'] == false
      @result = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
    elsif !on_grid(@word, @proposed_letters)
      @result = "Sorry but #{@word.upcase} can't be built out of #{@proposed_letters}"
    else
      @result = "Congratulations! #{@word.upcase} is a valid English word!"
      @score = "Your score is #{@word.length}"
    end
  end

  def on_grid(word, letters)
    word.chars.all? do |character|
      word.count(character) <= letters.count(character.upcase)
    end
  end

  def parsing(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary_entry_serialized = URI.open(url).read
    JSON.parse(dictionary_entry_serialized)
  end
end
