# require './lib/display'

class Board
#   include Display 

  attr_reader :board
  
  ROWS = 6
  COLS = 7
  PLACEHOLDER = "\u25EF"
  ORANGE_TOKEN = "\u{1F7E0}"
  RED_TOKEN = "\u{1F534}"
  RED_COMBO = Array.new(4, RED_TOKEN)
  ORANGE_COMBO = Array.new(4, ORANGE_TOKEN)

  def initialize
    @board = Array.new(ROWS) { Array.new(COLS, PLACEHOLDER) } 
  end

  def show
    # puts "  0   1   2   3   4   5   6  "
    puts "+---+---+---+---+---+---+---+"
    board.reverse.each do |row|
      puts "| " + row.each { |slot| slot }.join(' | ') + ' |'
      puts "+---+---+---+---+---+---+---+"
    end
    puts "  1   2   3   4   5   6   7  "
  end

  def valid_move?(player_input)
    player_input.between?(1, 7) && column_unfilled?(player_input)
  end

  def column_unfilled?(player_input)
    board.any? { |row| row[player_input - 1] == PLACEHOLDER }
  end

  def update(player_input, current_player_idx)
    board.each_with_index do |row, idx| 
      if board[idx][player_input - 1] == PLACEHOLDER
        place_token(player_input, current_player_idx, idx)
        break
      end
    end
  end

  def place_token(player_input, current_player_idx, idx)
    if current_player_idx.zero? 
      board[idx][player_input - 1] = RED_TOKEN
    else
      board[idx][player_input - 1] = ORANGE_TOKEN
    end
  end

  def game_over?
    horizontal_combo? || vertical_combo? || diagonal_combo?
  end

  def horizontal_combo?
    board.any? { |row| row.each_cons(4).any? { |a| a == RED_COMBO || a == ORANGE_COMBO } }
  end

  def vertical_combo?
    board.transpose.any? { |cols| cols.each_cons(4).any? { |a| a == RED_COMBO || a == ORANGE_COMBO } }
  end

  def diagonal_combo?
    diagonals = main_diagonals + anti_diagonals
    diagonals.any? { |diagonal| diagonal.each_cons(4).any? { |a| a == RED_COMBO || a == ORANGE_COMBO } }
  end

  def main_diagonals
    (0..board.size-4).map { |i| (0..board.size-1-i).map { |j| board[i+j][j] } }.
    concat((1..board.first.size-4).map { |j| (0..board.size-j-1).map { |i| board[i][j+i] } })
  end

  def anti_diagonals
    board_rotated = board.reverse
    (0..board_rotated.size-4).map { |i| (0..board_rotated.size-1-i).map { |j| board_rotated[i+j][j] } }.
    concat((1..board_rotated.first.size-4).map { |j| (0..board_rotated.size-j-1).map { |i| board_rotated[i][j+i] } })
  end

  def full?
    board.all? { |row| row.all? { |slot| slot != PLACEHOLDER } }
  end
end