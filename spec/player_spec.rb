require './lib/player'

describe Player do

  describe "#initialize" do
    name = 'John'
    token = "\u25CE"
    
    context 'when initializing a player' do
      it 'creates a player with given name' do
        
        player = Player.new(name, token)
        expect(player.name).to eq(name)
      end
    end
  end
end
