class Player
  attr_accessor :name, :mark

  def initialize(name, mark)
    @name = name
    @mark = mark
  end

  def make_move(grid)
    puts "#{@name}, enter the column to drop your token into:"
    column = gets.chomp.to_i - 1

    until column >= 0 && column <= 6 && check_column_valid?(column, grid)
      puts 'Please enter a number 1-7:'
      column = gets.chomp.to_i - 1
    end

    column
  end

  def check_column_valid?(column, grid)
    grid[5][column].is_a? Numeric
  end

  def create_move_row(column, grid)
    row = 0
    row += 1 until grid[row][column].is_a? Numeric

    row
  end
end
