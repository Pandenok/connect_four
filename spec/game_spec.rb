require './lib/game.rb'
require './lib/board.rb'
require './lib/player.rb'

describe Game do
  subject(:test_game) { described_class.new }

  describe "#initialize" do
    context 'when initializing a game' do 
      it 'creates an empty array for players' do 
        expect(test_game.players).to eq([])
      end

      it "sets a current player index to '0'" do
        expect(test_game.current_player_idx).to be_zero
      end
    
      it 'creates a new board' do
        expect(Board).to receive(:new)
        described_class.new
      end
    end
  end

  describe "#create_player" do
    name = 'Tom'

    it 'prompts for player\'s name' do
      allow(test_game).to receive(:puts)
      allow(test_game).to receive(:display_name_prompt).with(1)
      expect(test_game).to receive(:gets).and_return(name)
      test_game.create_player(1)
    end
    
    it 'calls Player class to create a new player' do
      allow(test_game).to receive(:puts)
      allow(test_game).to receive(:display_name_prompt).with(1)
      allow(test_game).to receive(:gets).and_return(name)
      expect(Player).to receive(:new).with(name)
      test_game.create_player(1)
    end
  end

  describe "#play_round" do
    context 'when playing one round' do
      player_input = '3'

      it 'prompts for player input' do
        allow(test_game).to receive(:puts)
        allow(test_game).to receive(:display_move_prompt)
        allow(test_game).to receive(:player_move)
        allow(test_game.board).to receive(:show)
        expect(test_game).to receive(:gets).and_return(player_input)
        test_game.play_round
      end

      it 'sends player move to board validation' do
        allow(test_game).to receive(:puts)
        allow(test_game).to receive(:display_move_prompt)
        allow(test_game).to receive(:gets).and_return(player_input)
        allow(test_game.board).to receive(:show)
        expect(test_game).to receive(:player_move)
        test_game.play_round
      end

      it 'switches to the next player' do
        allow(test_game).to receive(:puts)
        allow(test_game).to receive(:display_move_prompt)
        allow(test_game).to receive(:gets).and_return(player_input)
        allow(test_game).to receive(:player_move)
        allow(test_game.board).to receive(:show)
        expect(test_game).to receive(:next_player)
        test_game.play_round
      end

      it 'shows updated board' do
        allow(test_game).to receive(:puts)
        allow(test_game).to receive(:display_move_prompt)
        allow(test_game).to receive(:gets).and_return(player_input)
        allow(test_game).to receive(:player_move)
        allow(test_game).to receive(:next_player)
        expect(test_game.board).to receive(:show)
        test_game.play_round
      end

    end
  end

  describe "#player_move" do
    player_input = 1

    context 'when player makes a valid move' do
      it 'updates board' do
        allow(test_game.board).to receive(:show)
        expect(test_game.board).to receive(:update)
        test_game.player_move(player_input)
      end
    end

    context 'when player move is not valid' do
      it 'sends a notice' do
        player_input = 12
        allow(test_game).to receive(:puts)
        expect(test_game).to receive(:display_input_error)
        test_game.player_move(player_input)
      end
    end
  end

  describe "#current_player" do
    let(:test_player) { Player.new('TEST') }

    it 'returns current player' do
      test_game.players << test_player
      expect(test_game.current_player).to eq(test_player)
    end
  end

  describe "#next_player" do
    let(:first_test_player) { Player.new('Player_1') }
    let(:second_test_player) { Player.new('Player_2') }

    it 'switches player index' do
      test_game.players << first_test_player 
      test_game.players << second_test_player
      expect(test_game.next_player).to eq(1)
    end
  end

  describe "#configure new game" do
    before do 
      allow(test_game).to receive(:puts)
      allow(test_game).to receive(:display_welcome_intro)
    end

    context 'when a new game launched' do
      it 'sets up player one' do
        allow(test_game).to receive(:create_player).with(2)
        allow(test_game.board).to receive(:show)
        expect(test_game).to receive(:create_player).with(1)
        test_game.configure_new_game
      end
      it 'sets up player two' do
        allow(test_game).to receive(:create_player).with(1)
        allow(test_game.board).to receive(:show)
        expect(test_game).to receive(:create_player).with(2)
        test_game.configure_new_game
      end

      it 'shows playboard' do
        allow(test_game).to receive(:create_player).with(1)
        allow(test_game).to receive(:create_player).with(2)
        expect(test_game.board).to receive(:show)
        test_game.configure_new_game
      end
    end
  end

  describe "#game_finished?" do
    context 'when game over' do
      it 'is finished' do
        allow(test_game.board).to receive(:game_over?).and_return(true)
        expect(test_game).to be_game_finished
      end
    end
    context 'when the board is full' do
      it 'is finished' do
        allow(test_game.board).to receive(:full?).and_return(true)
        expect(test_game).to be_game_finished
      end
    end
  end

  describe "#announce_results" do
    context 'when game over' do
      it 'announces the winner' do 
        allow(test_game.board).to receive(:game_over?).and_return(true)
        allow(test_game).to receive(:puts)
        expect(test_game).to receive(:display_congratulations)
        test_game.announce_results
      end
    end

    context 'when the board is full' do
      it 'is a tie' do
        allow(test_game.board).to receive(:full?).and_return(true)
        allow(test_game).to receive(:puts)
        expect(test_game).to receive(:display_tie)
        test_game.announce_results
      end
    end
  end
  
  describe "#play" do
    context "when playing a game" do
      it 'configures a new game' do
        allow(test_game).to receive(:play_round)
        allow(test_game).to receive(:game_finished?).and_return(true)
        allow(test_game).to receive(:announce_results)
        allow(test_game).to receive(:restart_game)
        expect(test_game).to receive(:configure_new_game)
        test_game.play
      end

      it 'loops until the game is finished' do
        allow(test_game).to receive(:configure_new_game)
        allow(test_game).to receive(:announce_results)
        allow(test_game).to receive(:game_finished?).and_return(false, false, false, true)
        allow(test_game).to receive(:restart_game)
        expect(test_game).to receive(:play_round).exactly(3).times
        test_game.play
      end

      it 'announces results of the game' do
        allow(test_game).to receive(:configure_new_game)
        allow(test_game).to receive(:play_round)
        allow(test_game).to receive(:game_finished?).and_return(true)
        allow(test_game).to receive(:restart_game)
        expect(test_game).to receive(:announce_results)
        test_game.play
      end

      it 'prompts for another game' do
        allow(test_game).to receive(:configure_new_game)
        allow(test_game).to receive(:play_round)
        allow(test_game).to receive(:game_finished?).and_return(true)
        allow(test_game).to receive(:announce_results)
        allow(test_game).to receive(:puts)

        expect(test_game).to receive(:restart_game)
        test_game.play
      end
    end
  end

  describe "#restart_game" do
    it 'prompts for a new game' do
      allow(test_game).to receive(:puts)
      expect(test_game).to receive(:display_restart_game_prompt)
      test_game.restart_game
    end

    context 'when the answer is YES' do
      it 'reboots the game' do
        input = 'y'
        allow(test_game).to receive(:puts)
        allow(test_game).to receive(:display_restart_game_prompt)
        allow(test_game).to receive(:gets).and_return(input)
        expect(Game).to receive(:new)
        # expect(Game).to receive(:new).and(:play)
        test_game.restart_game
      end
    end

    context 'when the answer is NO' do
      it 'farewells' do
        input = ''
        allow(test_game).to receive(:gets).and_return(input)
        allow(test_game).to receive(:puts)
        expect(test_game).to receive(:display_farewell)
        test_game.restart_game
      end
    end
  end
end