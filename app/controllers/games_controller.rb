require 'open-uri'

class GamesController < ApplicationController
  def new
    session[:score] = 0 if session[:score].nil?
    @current_score = session[:score]
    @letters = Array.new(9) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters]
    @score = @word.length
    is_in_letters = @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) }
    real_word = check_english_word(@word)
    if is_in_letters && real_word
      @result = "Congratulations! #{@word} is a valid English word!"
      session[:score] += @score
      @current_score = session[:score]
    elsif !real_word && is_in_letters
      @result = "Sorry but #{@word} does not appear to be a valid English word..."
    else
      @result = "Sorry but #{@word} can't be built out of #{@letters.split.join(", ")}"
    end
  end

  def check_english_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_hash = JSON.parse(URI.open(url).read)
    word_hash["found"]
  end
end
