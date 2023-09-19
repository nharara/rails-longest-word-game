require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(a e i o u y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('a'..'z').to_a - VOWELS).sample }
    @letters.shuffle!
  end
  # def new
  #   @letters = generate_random_letters(10)
  # end

  # def generate_random_letters(length)
  #   letters = ('a'..'z').to_a
  #   Array.new(length) { letters.sample }
  # end

  def score
    @saved_letters = params[:letters].split('')
    @user_guess = params[:query]

    url = "https://wagon-dictionary.herokuapp.com/#{@user_guess}"
    read_url = URI.open(url).read
    @okay = JSON.parse(read_url)

    if valid?
      if @okay['found'] == true
        @result = "Congratulations! '#{@user_guess}' can be made out of these letters 🙏"
      else
        @result = "#{@user_guess} is not an English word 😅"
      end
    else
      @result = "#{@user_guess} can't be made out of these letters 😔"
    end
  end

  def valid?
    @user_guess.split('').all? { |letter| @saved_letters.count(letter) >= @user_guess.count(letter) }
  end
end
