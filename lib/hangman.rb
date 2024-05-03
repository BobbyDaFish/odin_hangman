# frozen_string_literal: true

require 'json'

# Game board and methods
class Game
  def new_answer
    word_list = File.readlines('word_dictionary.txt')
    answer = word_list[rand(word_list.length)].chop while answer == nil || answer.length > 12 || answer.length < 5

    answer.split(//)
  end

  def display_game(board, health)
    puts board.join(' ')
    puts "Health: #{health}"
  end

  def save_game(answer, board, health, alphabet)
    state = { 'answer' => answer, 'board' => board, 'health' => health, 'alphabet' => alphabet }
    save_file = save_file_check

    File.open(save_file, 'w') do |json|
      json << state.to_s.gsub('=>', ': ')
    end
    puts 'Game saved!'
  end

  def save_file_check
    File.write('../save_game.json', '') unless File.exist?('../save_game.json')
    File.open('../save_game.json')
  end

  def load_save_file
    save_file = File.open('../save_game.json')
    json = save_file.readline
    state = JSON.parse(json, { symbolize_names: true })
    puts "-----\n\nGame loaded!"
    display_game(state[:board], state[:health])
    state
  end

  def get_player_choice(state)
    puts state[:alphabet].join(', ')
    puts 'Choose a letter from the remaining alphabet'
    valid_player_choice(gets.chop.downcase, state)
  end

  def valid_player_choice(letter, state)
    l = letter
    until state[:alphabet].any?(l)
      puts "-----\n\nInvalid choice, please select one letter from the available letters."
      l = gets.chop.downcase
    end
    l
  end

  def check_play(player_choice, state)
    puts "-----\n\nThat letter has already been used!" unless state[:alphabet].any?(player_choice)
    if state[:answer].any?(player_choice)
      puts "-----\n\nYes! Marking that letter."
      state = process_play(player_choice, state)
    else
      puts "-----\n\nSorry, not that one!"
      state[:health] -= 1
    end
    state[:alphabet][state[:alphabet].index(player_choice)] = '_'
    state
  end

  def process_play(player_choice, state)
    state[:answer].each_with_index do |l, i|
      next unless l == player_choice

      state[:answer][i] = '_'
      state[:board][i] = l
    end
    state
  end

  def load?(string, state)
    until [string].include?('y') || [string].include?('n')
      puts "-----\n\nInvalid selection.\nDo you want to load your game? Input Y for yes, N for no."
      string = gets.chop.downcase
    end
    if string == 'y'
      load_save_file
    elsif string == 'n'
      state
    end
  end

  def save?(string, state)
    until [string].include?('y') || [string].include?('n')
      puts "-----\n\nInvalid selection.\nDo you want to save your game? Input Y for yes, N for no."
      string = gets.chop.downcase
    end
    if string == 'y'
      save_game(state[:answer], state[:board], state[:health], state[:alphabet])
    elsif string == 'n'
      state
    end
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
if File.exist?('../save_game.json')
  puts 'Save game file found. Do you want to load your game? Input Y for yes, N for no.'
  state = hangman.load?(gets.chop.downcase, state)
end
while state[:board].any?('_') && state[:health].positive?
  state = hangman.check_play(hangman.get_player_choice(state), state)
  hangman.display_game(state[:board], state[:health])
  puts 'Do you want to save your game?'
  hangman.save?(gets.chop.downcase, state)
end
if state[:health].zero?
  puts 'You\'re out of health, you lose!'
elsif state[:board].any?('_') == false
  puts "You got the word! It\'s #{state[:board].join}!"
end
