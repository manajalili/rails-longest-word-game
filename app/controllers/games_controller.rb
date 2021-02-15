require 'open-uri'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)
  # %w(foo bar) is a shortcut for ["foo", "bar"].

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { ('A'..'Z').to_a.sample }
    # raise
    @letters.shuffle!
    # @scores = session[:scores]
  end

  def score
    @letters = params[:letters].split
    # with or without split works
    # the params[:letter] give us glocal access to letters
    @word = (params[:word] || '').upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)

    # @sum = 0
    @sum = @word.size
    session[:scores] = 0

    if session[:scores].nil?
      session[:scores] = @word
    # else
    #   session[:scores] << @word
    end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
    # it goes through the characters of the word, and check if the count of each
    # charater in word is either = or less than the count of letters in letters
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
