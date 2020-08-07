require './lib/player'

describe Player do

  describe "#initialize" do
    context 'when initializing a player with specified name' do
      it 'creates a player with that name' do
        name = 'John' 
        player = Player.new(name)
        expect(player.name).to eq(name)
      end
    end

    context 'when initializing a player without name' do
      it 'creates a player with default name' do
        player = Player.new
        expect(player.name).to eq('Nickname')
      end
    end
  end
end
