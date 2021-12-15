module Advent
  class Grid
    def initialize(initial)
      @grid = Array(initial)
    end

    def column_size
      @grid.first.size
    end

    def row_size
      @grid.size
    end

    def size
      column_size * row_size
    end

    def [](*args)
      row, column = args

      return @grid[row][column] if args.length == 2
      return @grid[row]         if args.length == 1
      raise ArgumentError.new("wrong number of arguments (given #{args.length}, expected 1..2")
    end

    def to_a
      @grid
    end

    def rows
      to_a
    end

    def columns
      to_a.transpose
    end

    def each(coordinates: false)
      return enum_for(__method__, coordinates: coordinates) unless block_given?

      if coordinates
        @grid.each_with_index do |row, r|
          row.each_with_index do |value, c|
            yield(value, [r, c])
          end
        end

      else
        @grid.each do |row|
          row.each do |value|
            yield(value)
          end
        end
      end

      self
    end

    def adjacent(row, column, coordinates: false)
      return enum_for(__method__, row, column, coordinates: coordinates) unless block_given?

      adjacent = {}
      adjacent[ [row - 1, column    ] ] = @grid[row - 1][column    ] if row > 0                                        # N
      adjacent[ [row - 1, column + 1] ] = @grid[row - 1][column + 1] if row > 0            && column < column_size - 1 # NE
      adjacent[ [row    , column + 1] ] = @grid[row    ][column + 1] if                       column < column_size - 1 # E
      adjacent[ [row + 1, column + 1] ] = @grid[row + 1][column + 1] if row < row_size - 1 && column < column_size - 1 # SE
      adjacent[ [row + 1, column    ] ] = @grid[row + 1][column    ] if row < row_size - 1                             # S
      adjacent[ [row + 1, column - 1] ] = @grid[row + 1][column - 1] if row < row_size - 1 && column > 0               # SW
      adjacent[ [row    , column - 1] ] = @grid[row    ][column - 1] if                       column > 0               # W
      adjacent[ [row - 1, column - 1] ] = @grid[row - 1][column - 1] if row > 0            && column > 0               # NW

      adjacent.each do |(r, c), value|
        coordinates ? yield(value, [r, c]) : yield(value)
      end

      self
    end
  end
end

if __FILE__ == $0

  grid = Advent::Grid.new([
    ["a", "b", "c"],
    ["d", "e", "f"],
    ["g", "h", "i"]
  ])

  grid.each(&:ord)

  whole = grid.each(coordinates: true).to_a
  fail unless whole.length == 9
  fail unless whole.first == ["a", [0, 0]]

  adjacent = grid.adjacent(2, 2, coordinates: true).to_a
  fail unless adjacent.length == 3
  fail unless adjacent.first == ["f", [1, 2]]

  grid.rows.each
  grid.columns.each

  fail unless grid.row_size == 3
  fail unless grid.column_size == 3

  fail unless grid[0, 1] == "b"
  fail unless grid[0] == ["a", "b", "c"]

  fail unless grid.to_a.object_id == grid.instance_variable_get(:@grid).object_id

end
