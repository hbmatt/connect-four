class Board
  attr_accessor :grid

  def initialize(rows = 6, columns = 7)
    @rows = rows
    @columns = columns
    @grid = []
  end

  def make_board
    @grid = []

    @rows.times do
      i = 1
      row = []
      until i > @columns
        row << i
        i += 1
      end
      @grid << row
    end

    @grid
  end

  def display_board
    display = ''
    @grid.reverse.each do |row|
      i = 0
      display += '| '
      until i > 6
        display += "#{row[i]} | "
        i += 1
      end
      display = display.strip
      display += "\n"
    end
    display += '+---------------------------+'

    puts display
  end

  def mark_board(position, mark)
    row = position[0]
    column = position[1]

    @grid[row][column] = mark
  end
end
