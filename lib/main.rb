require_relative 'board.rb'
require_relative 'display.rb'
require_relative 'game.rb'

include Display

def start_game
  game = Game.new
  game.play
  restart_game
end

def restart_game
  puts display_restart_game_prompt
  input = gets.chomp.downcase
  if input == 'y'
    start_game
  else
    puts display_farewell
  end
end

start_game