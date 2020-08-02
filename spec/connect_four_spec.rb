require './lib/board.rb'
require './lib/player.rb'
require './lib/game.rb'

describe Board do
  board = Board.new
  board.make_board

  describe '#make_board' do
    it 'creates a grid of six rows' do
      expect(board.grid.length).to eq(6)
    end

    it 'creates a grid of seven columns' do
      expect(board.grid[0].length).to eq(7)
    end
  end

  describe '#display_board' do
    it 'creates a visual of the board' do
      visual = "\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n+---------------------------+"
      expect(board.display_board).to eq(puts visual)
    end
  end

  describe '#mark_board' do
    it "places the player's mark in the cell they chose" do
      expect(board.mark_board([1, 5], "\u25EF")).to eq("\u25EF")
    end
  end
end

describe Player do
  player = Player.new('Player 1', "\u25EF")
  board = Board.new
  board.make_board
  board.mark_board([0, 5], "\u25EF")

  describe '#make_move' do
    it 'returns column input from player' do
      allow(player).to receive(:gets) { '5' }
      expect(player.make_move(board.grid)).to eq(4)
    end

    it 'outputs error if move invaid' do
      allow(player).to receive(:gets).and_return('abc', '2')
      expect { player.make_move(board.grid) }.to output("Player 1, enter the column to drop your token into:\nPlease enter a number 1-7:\n").to_stdout
    end
  end

  describe '#check_column_valid?' do
    it 'returns true when there is space in a column' do
      expect(player.check_column_valid?(5, board.grid)).to eq(true)
    end

    it 'returns false when a column is full' do
      board.grid[5][6] = "\u25EF"
      expect(player.check_column_valid?(6, board.grid)).to eq(false)
    end
  end

  describe '#check_move_row' do
    it 'returns the available row' do
      expect(player.create_move_row(5, board.grid)).to eq(1)
    end
  end
end

describe Game do
  game = Game.new
  board = Board.new

  describe '#check_win?' do
    it 'returns true when a player has a winning set of horizontal moves' do
      board.make_board
      board.grid[5][1] = "\u25EF"
      board.grid[5][2] = "\u25EF"
      board.grid[5][3] = "\u25EF"
      board.grid[5][4] = "\u25EF"

      expect(game.check_win?(board.grid,"\u25EF")).to eq(true)
    end

    it 'returns true when a player has a winning set of vertical moves' do
      board.make_board
      board.grid[0][1] = "\u25EF"
      board.grid[1][1] = "\u25EF"
      board.grid[2][1] = "\u25EF"
      board.grid[3][1] = "\u25EF"

      expect(game.check_win?(board.grid,"\u25EF")).to eq(true)
    end

    it 'returns true when a player has a winning set of ascending diagonal moves' do
      board.make_board
      board.grid[0][1] = "\u25EF"
      board.grid[1][2] = "\u25EF"
      board.grid[2][3] = "\u25EF"
      board.grid[3][4] = "\u25EF"

      expect(game.check_win?(board.grid,"\u25EF")).to eq(true)
    end

    it 'returns true when a player has a winning set of descending diagonal moves' do
      board.make_board
      board.grid[0][4] = "\u25EF"
      board.grid[1][3] = "\u25EF"
      board.grid[2][2] = "\u25EF"
      board.grid[3][1] = "\u25EF"

      expect(game.check_win?(board.grid,"\u25EF")).to eq(true)
    end

    it 'returns false when a player has no winning moves' do
      board.make_board
      board.grid[0][0] = "\u25EF"
      board.grid[5][5] = "\u25EF"
      board.grid[2][2] = "\u25EF"
      board.grid[5][6] = "\u25EF"

      expect(game.check_win?(board.grid,"\u25EF")).to eq(false)
    end
  end

  describe '#get_players' do
    it 'stores the players names into their instance variables' do
      allow(game).to receive(:gets).and_return('Cheese', 'Pizza')
      game.get_players
      expect(game.player1.name).to eq('Cheese')
      expect(game.player2.name).to eq('Pizza')
    end
  end

  describe '#choose_player_turn' do
    it 'returns player 1 when move count is odd' do
      game.move_counter = 5
      expect(game.choose_player_turn).to eq(game.player1)
    end

    it 'returns player 2 when move count is even' do
      game.move_counter = 6
      expect(game.choose_player_turn).to eq(game.player2)
    end
  end

  describe '#start_player_turn' do
    it "marks board at chosen column with player's mark" do
      game.board.make_board
      allow(game.player1).to receive(:make_move).and_return(3)
      allow(game.player1).to receive(:create_move_row).and_return(0)
      expect(game.start_player_turn(game.player1)).to eq("\u25EF")
      expect(game.board.grid[0][3]).to eq("\u25EF")
    end
  end

  describe '#start_game' do
    it 'calls #end_game when the board is full' do
      visual = "\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n+---------------------------+"
      game.move_counter = 43
      allow(game).to receive(:get_players).and_return(true)
      expect{game.start_game}.to output(puts visual + "\nGame over! It's a draw!").to_stdout
    end
  end

  describe "#end_game" do
    it 'declares a winner when there is one' do
      game.player1.name = 'Player 1'
      allow(game).to receive(:restart).and_return(false)
      expect{game.end_game(game.player1)}.to output("\nGame over! Player 1 wins!\n").to_stdout
    end

    it 'declares a draw with no winner' do
      allow(game).to receive(:restart).and_return(false)
      expect{game.end_game}.to output("\nGame over! It's a draw!\n").to_stdout
    end
  end

  describe '#restart' do
    it 'exits program when player answers N' do
      allow(game).to receive(:gets).and_return('N')
      expect(game.restart).to eq(exit)
    end

    it "returns error when player doesn't choose Y or N" do
      allow(game).to receive(:gets).and_return('yes', 'N')
      expect{game.restart}.to output("\nPlay again? [Y/N]\nPlease enter Y or N:\n\nGoodbye!\n").to_stdout
    end
  end
end
