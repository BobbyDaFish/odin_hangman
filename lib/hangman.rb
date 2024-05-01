# frozen_string_literal: true
require 'pry-byebug'

def new_answer
  word_list = File.readlines('word_dictionary.txt')
  answer = word_list[rand(word_list.length)].chop while answer.length > 12 || answer.length < 5

  answer
end
