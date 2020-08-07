require './lib/player'

describe Player do

  describe "#initialize" do
    name = 'John'
    checker = "\u25CE"
    
    context 'when initializing a player' do
      it 'creates a player with given name' do
        
        player = Player.new(name, checker)
        expect(player.name).to eq(name)
      end
    end
  end
end
