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
    state = { 'answer' => answer, 'board' => board, 'health' => health, 'alphabet' => alphabet }
    save_file = save_file_check

    File.open(save_file, 'w') do |json|
      json << state.to_s.gsub('=>', ': ')
    end
  end

  def save_file_check
    File.write('../save_game.json', '') unless File.exist?('../save_game.json')
    File.open('../save_game.json')
  end

  def load_save_file
    save_file = File.open('../save_game.json')
    json = save_file.readline
    JSON.parse(json,  {symbolize_names: true })
  end
end

hangman = Game.new
state = {
  answer: hangman.new_answer,
  board: Array.new(1, '_'),
  health: 5,
  alphabet: %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
}
state[:board] = Array.new(state[:answer].length, '_')
hangman.save_game(state[:answer], state[:board], state[:health], state[:alphabet])
state = hangman.load_save_file
puts state
