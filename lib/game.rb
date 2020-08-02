class Game
  attr_accessor :board, :player1, :player2, :move_counter

  def initialize
    @board = Board.new
    @player1 = Player.new('Player 1', "\u25EF")
    @player2 = Player.new('Player 2', "\u25CF")
    @move_counter = 1
  end

  def start_game
    puts "\nLet's Play Connect Four!\n"
    get_players

    @board.make_board
    @board.display_board

    until @move_counter > 42
      player = choose_player_turn
      start_player_turn(player)
      @board.display_board
      if check_win?(@board.grid, player.mark)
        end_game(player)
      else
        @move_counter += 1
      end
    end

    end_game
  end

  def end_game(player = 'draw')
    return puts "\nGame over! It's a draw!" if player == 'draw'

    puts "\nGame over! #{player.name} wins!"

    restart()
  end

  def restart
    puts "\nPlay again? [Y/N]"
    answer = gets.chomp.upcase

    unless answer == 'Y' || answer == 'N'
      puts "Please enter Y or N:"
      answer = gets.chomp.upcase
    end

    if answer == 'Y'
      Game.new.start_game
    else
      puts "\nGoodbye!"
      exit
    end
  end

  def get_players
    puts "\nPlayer 1, enter your name:"
    @player1.name = gets.chomp
    puts "\nPlayer 2, enter your name:"
    @player2.name = gets.chomp
  end

  def choose_player_turn
    if @move_counter.odd?
      puts "\nPlayer 1's turn"
      @player1
    elsif @move_counter.even?
      puts "\nPlayer 2's turn"
      @player2
    end
  end

  def start_player_turn(player)
    column = player.make_move(@board.grid)
    row = player.create_move_row(column, @board.grid)
    position = [row, column]
    @board.mark_board(position, player.mark)
  end

  def check_win?(grid, mark)
    check_horizontal?(grid, mark) || check_vertical?(grid, mark) || check_ascending_diagonal?(grid, mark) || check_descending_diagonal?(grid, mark) ? true : false
  end

  def check_horizontal?(grid, mark)
    i = 0

    while i <= 5
      column = 0

      while column <= 3
        if grid[i][column] == mark && grid[i][column] == grid[i][column + 1] && grid[i][column + 1] == grid[i][column + 2] && grid[i][column + 2] == grid[i][column + 3]
          return true
        else
          column += 1
        end
      end
      i += 1
    end

    false
  end

  def check_vertical?(grid, mark)
    i = 0

    while i <= 6
      row = 0

      while row <= 2
        if grid[row][i] == mark && grid[row][i] == grid[row + 1][i] && grid[row + 1][i] == grid[row + 2][i] && grid[row + 2][i] == grid[row + 3][i]
          return true
        else
          row += 1
        end
      end
      i += 1
    end

    false
  end

  def check_ascending_diagonal?(grid, mark)
    i = 0

    while i <= 2
      column = 0

      while column <= 3
        if grid[i][column] == mark && grid[i][column] == grid[i + 1][column + 1] && grid[i + 1][column + 1] == grid[i + 2][column + 2] && grid[i + 2][column + 2] == grid[i + 3][column + 3]
          return true
        else
          column += 1
        end
      end
      i += 1
    end

    false
  end

  def check_descending_diagonal?(grid, mark)
    i = 0

    while i <= 2
      column = 6

      while column >= 3
        if grid[i][column] == mark && grid[i][column] == grid[i + 1][column - 1] && grid[i + 1][column - 1] == grid[i + 2][column - 2] && grid[i + 2][column - 2] == grid[i + 3][column - 3]
          return true
        else
          column -= 1
        end
      end
      i += 1
    end

    false
  end
end
