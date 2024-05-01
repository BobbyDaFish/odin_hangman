# frozen_string_literal: true

require 'pry-byebug'
require 'json'

# Game board and methods
class Game
  def new_answer
    word_list = File.readlines('word_dictionary.txt')
    answer = word_list[rand(word_list.length)].chop while answer == nil || answer.length > 12 || answer.length < 5

    answer.split(//)
  end

  def display_game(board, alphabet)
    puts alphabet.join(', ')
    puts board.join(' ')
  end

  def save_game(answer, board, health, alphabet)
    state = { 'answer' => answer, 'board' => board, 'health' => health, 'alphabet' => alphabet }.to_s
    save_file = save_file_check
    save_data = JSON.parse(state.gsub('=>', ': '))

    File.open(save_file, 'w') do |json|
      json << save_data
    end
  end

  def save_file_check
    File.write('../save_game.json', '') unless File.exist?('../save_game.json')
    File.open('../save_game.json')
  end

end

alphabet = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
hangman = Game.new
answer = hangman.new_answer
board = Array.new(answer.length, '_')
health = 5
