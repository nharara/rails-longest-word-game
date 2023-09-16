require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = generate_random_letters(10)
  end

  def generate_random_letters(length)
    letters = ('a'..'z').to_a
    Array.new(length) { letters.sample }
  end

  def score
    @saved_letters = params[:letters].split('')
    @user_guess = params[:query]

    @valid = @user_guess.split('').all? { |letter| @saved_letters.count(letter) >= @user_guess.count(letter) }

    # if @vali
    #   @message = "Can make that word"
    # else
    #   @message = "Cannot make that word out of the letters"
    # end
    url = "https://wagon-dictionary.herokuapp.com/#{@user_guess}"
    read_url = URI.open(url).read
    @okay = JSON.parse(read_url)

    if @valid && @okay['found'] == true
      @result = "Congratulations! '#{@user_guess}.capitalize' can be made out of these letters"
    elsif @valid && @okay['found'] == false
      @result = "#{@user_guess} is a word but can't be made out of these letters."
    else
      @result = "#{@user_guess} is not a word"
    end
  end
end
