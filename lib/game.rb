# frozen_string_literal: true

require './lib/display'

class Game
  include Display

  attr_reader :players, :current_player_idx, :board

  def initialize
    @players = []
    @current_player_idx = 0
    @board = Board.new
  end

  def create_player(player_number)
    print display_name_prompt(player_number)
    name = gets.chomp
    players << Player.new(name, assign_checker(player_number))
  end

  def assign_checker(player_number)
    player_number.eql?(1) ? Board::RED_CHECKER : Board::ORANGE_CHECKER
  end

  def play_round
    print display_move_prompt
    player_input = gets.chomp.to_i
    player_move(player_input)
    next_player
  end

  def player_move(player_input)
    if board.valid_move?(player_input)
      board.update(player_input, current_player_idx)
      board.show
    else
      puts display_input_error
    end
  end

  def current_player
    players[current_player_idx]
  end

  def next_player
    @current_player_idx = (@current_player_idx + 1) % 2
  end

  def configure_new_game
    puts display_welcome_intro
    create_player(1)
    create_player(2)
    puts display_game_rules
    board.show
  end

  def game_finished?
    board.game_over? || board.full?
  end

  def announce_results
    puts display_congratulations if board.game_over?
    puts display_tie if board.full?
  end

  def play
    configure_new_game
    play_round until game_finished?
    announce_results
    # restart_game
  end

  # def restart_game
  #   puts display_restart_game_prompt
  #   input = gets.chomp.downcase
  #   if input == 'y'
  #     Game.new.play
  #   else
  #     puts display_farewell
  #   end
  # end
end
