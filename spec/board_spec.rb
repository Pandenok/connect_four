require './lib/board'

describe Board do
  subject(:test) { described_class.new }
  let(:red_token) { "\u{1F534}" }
  let(:orange_token) { "\u{1F7E0}" }
  
  describe "#initialize" do
    context 'when initializing a board' do
      it 'is a grid of 6 rows and 7 cols' do
        default_board = [["◯", "◯", "◯", "◯", "◯", "◯", "◯"],
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"],
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"]]
        expect(test.board).to eq(default_board)
      end
    end
  end

  describe "#show" do
    context "when asked to visualize a board" do
      it 'shows the board' do
        printed_board = 
            <<~HEREDOC
            +---+---+---+---+---+---+---+
            | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ |
            +---+---+---+---+---+---+---+
            | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ |
            +---+---+---+---+---+---+---+
            | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ |
            +---+---+---+---+---+---+---+
            | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ |
            +---+---+---+---+---+---+---+
            | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ |
            +---+---+---+---+---+---+---+
            | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ | ◯ |
            +---+---+---+---+---+---+---+
              1   2   3   4   5   6   7  
            HEREDOC
        expect { test.show }.to output(printed_board).to_stdout
      end
    end
  end

  describe "#valid_move?" do
    context 'when input is between 0 and 6' do
      it 'is valid move' do 
        player_input = 3
        validation_result = test.valid_move?(player_input)
        
        expect(validation_result).to be true
      end
    end

    context 'when input is not between 0 and 6' do
      it 'is not valid move' do
        player_input = 8
        validation_result = test.valid_move?(player_input)
        
        expect(validation_result).to be false
      end
    end

    context 'when the column is full' do
      it 'is not valid move' do
        player_input = 3
        allow(test).to receive(:column_unfilled?).and_return false

        validation_result = test.valid_move?(player_input)
        
        expect(validation_result).to be false
      end
    end
  end

  describe "#column_unfilled?" do
    context 'when there is at least one empty slot in the column' do
      it 'is unfilled' do
        player_input = 4
        test.instance_variable_set(:@board, [["◯", "◯", "◯", red_token, "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", orange_token, "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", red_token, "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", orange_token, "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", red_token, "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"]])
        result_column_checking = test.column_unfilled?(player_input)
        expect(result_column_checking).to be true
      end
    end

    context 'when all slots are occupied' do
      it 'is full' do
        player_input = 4
        test.instance_variable_set(:@board, [["◯", "◯", "◯", red_token, "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", orange_token, "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", red_token, "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", orange_token, "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", red_token, "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", orange_token, "◯", "◯", "◯"]])
        result_column_checking = test.column_unfilled?(player_input)
        expect(result_column_checking).to be false
      end
    end
  end

  describe "#update" do
    context 'when board is empty' do
      it 'puts token on the last row' do
        player_input = 4
        current_player_idx = 0
        updated_board = [["◯", "◯", "◯", red_token, "◯", "◯", "◯"],
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"],
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"]]
        test.update(player_input, current_player_idx)
        expect(test.board).to eq(updated_board)
      end
    end

    context 'when the slot is occupied' do
      it 'places a token to the same slot on the other row' do
        player_input = 4
        current_player_idx = 0
        test.instance_variable_set(:@board, [["◯", "◯", "◯", red_token, "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"]])
        updated_board = [["◯", "◯", "◯", red_token, "◯", "◯", "◯"],
                         ["◯", "◯", "◯", red_token, "◯", "◯", "◯"], 
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"],
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                         ["◯", "◯", "◯", "◯", "◯", "◯", "◯"]]
        test.update(player_input, current_player_idx)
        expect(test.board).to eq(updated_board)
      end
    end
  end

  describe "#horizontal_combo?" do
    context 'when reads four identical tokens in a row' do
      it 'is horizontal combo' do
        test.instance_variable_set(:@board, [[red_token, red_token, red_token, red_token, "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"]])
        expect(test).to be_horizontal_combo
      end
    end
  end

  describe "#vertical_combo?" do
    context 'when reads four identical tokens in a column' do
      it 'is vertical combo' do
        test.instance_variable_set(:@board, [["◯", "◯", "◯", "◯", "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             [red_token, "◯", "◯", "◯", "◯", "◯", "◯"],
                                             [red_token, "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             [red_token, "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             [red_token, "◯", "◯", "◯", "◯", "◯", "◯"]])
        expect(test).to be_vertical_combo
      end
    end
  end

  describe "#diagonal_combo?" do
    context 'when reads four identical tokens in a diagonal' do
      it 'is diagonal combo' do
        test.instance_variable_set(:@board, [["◯", "◯", "◯", "◯", "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", red_token, "◯", "◯", "◯"],
                                             ["◯", "◯", red_token, "◯", "◯", "◯", "◯"], 
                                             ["◯", red_token, "◯", "◯", "◯", "◯", "◯"], 
                                             [red_token, "◯", "◯", "◯", "◯", "◯", "◯"]])
        expect(test).to be_diagonal_combo
      end
    end
  end

  describe "#game_over?" do
    context 'when reads four identical tokens in horizontal, vertical or diagonal' do
      it 'is game over' do
        test.instance_variable_set(:@board, [["◯", red_token, "◯", "◯", "◯", "◯", "◯"],
                                             ["◯", "◯", red_token, "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", red_token, "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", "◯", red_token, "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"]])
        expect(test).to be_game_over
      end
    end

    context 'when there is no sequence of four identical tokens' do
      it 'is not game over' do 
        test.instance_variable_set(:@board, [["◯", red_token, "◯", "◯", "◯", "◯", "◯"],
                                             ["◯", "◯", red_token, "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", orange_token, "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", "◯", red_token, "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"]])
        expect(test).to_not be_game_over
      end
    end
  end

  describe "#full?" do
    context 'when no more slots available to place a token' do
      it 'is full' do
        test.instance_variable_set(:@board, [[orange_token, red_token, red_token, red_token, orange_token, orange_token, orange_token],
                                             [orange_token, red_token, red_token, red_token, orange_token, orange_token, orange_token], 
                                             [red_token, orange_token, orange_token, orange_token, red_token, red_token, red_token],
                                             [red_token, orange_token, orange_token, orange_token, red_token, red_token, red_token], 
                                             [red_token, red_token, orange_token, orange_token, red_token, orange_token, orange_token], 
                                             [orange_token, red_token, red_token, red_token, orange_token, orange_token, orange_token]])
        expect(test).to be_full
      end
    end

    context 'when there are slots to place a token' do
      it 'is not full' do
        test.instance_variable_set(:@board, [["◯", red_token, "◯", "◯", "◯", "◯", "◯"],
                                             ["◯", "◯", red_token, "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", orange_token, "◯", "◯", "◯"],
                                             ["◯", "◯", "◯", "◯", red_token, "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"], 
                                             ["◯", "◯", "◯", "◯", "◯", "◯", "◯"]])
        expect(test).to_not be_full
      end
    end
  end
end