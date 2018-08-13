require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do |i|
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    result(@word)
    @start_time = Time.parse(params[:start_time])
    end_time = Time.now
    time_to_answer = (end_time - @start_time)
    @player_score = @word.length + 1 - time_to_answer
  end

  def result(word)
    @result = ''
    if word_in_grid?(word)
      if english_word?(word)
        @result = "bravo"
      else
        @result = "not an english word"
      end
    else
      @result = "le mot n'est pas dans la grille"
    end
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    @word_new = JSON.parse(word_serialized)
    return @word_new['found']
  end

  def word_in_grid?(word)
    chars_match_grid = false
    word.upcase.chars.each do |lettre|
      index = @letters.index(lettre)
      if @letters.index(lettre)
        @letters.delete_at(index)
        chars_match_grid = true
      else
        chars_match_grid = false
        break
      end
    end
  end
end
