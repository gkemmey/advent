module Year2021
  module Day04
    class Test < Advent::ChallengeTest
      with_example <<~TXT, part_one: 4512, part_two: 1924
        7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

        22 13 17 11  0
         8  2 23  4 24
        21  9 14 16  7
         6 10  3 18  5
         1 12 20 15 19

         3 15  0  2 22
         9 18 13 17  5
        19  8  7 25 23
        20 11 10 24  4
        14 21 16 12  6

        14 21 17 24  4
        10 16 15  9 19
        18  8 23 26 20
        22 11 13  6  5
         2  0 12  3  7
      TXT

      with_input part_one: 22680, part_two: 16168
    end

    class Board
      def self.parse(lines)
        new(lines.collect { |l| l.split(/\s+/).reject(&:empty?).map(&:to_i) })
      end

      attr_reader :board, :marks

      def initialize(board)
        @board = board
        @marks = @board.map { |row| row.map { |column| false } }
      end

      def mark(number)
        board.each_with_index do |row, i|
          row.each_with_index do |column, j|
            @marks[i][j] = true if column == number
          end
        end
      end

      def finished?
        marks.any? { |row| row.all? } ||
          marks.transpose.any? { |column| column.all? }
      end

      def sum_of_the_unmarked
        marks.flat_map.with_index { |row, i|
          row.map.with_index { |marked, j|
            marked ? nil : board[i][j]
          }
        }.compact.sum
      end
    end

    class Game
      def self.parse(tape, boards)
        new(
          tape.flat_map { |l| l.split(",").map(&:to_i) },
          boards.collect { |b| Board.parse(b) }
        )
      end

      attr_reader :tape, :boards, :turn, :finished

      def initialize(tape, boards)
        @tape = tape
        @boards = boards
        @turn = 0
        @finished = []
      end

      def last_number_marked
        tape[turn - 1]
      end

      # ------- first to finish wins --------

      def play
        until finished.any? || turn > tape.length
          boards.each { |b|
            b.mark(tape[turn])
            @finished << b if b.finished? && !finished.include?(b)
          }

          @turn += 1
        end
      end

      def winner
        finished.first
      end

      def final_score
        winner.sum_of_the_unmarked * last_number_marked
      end

      # -------- last to finish "wins" --------

      def play_last_to_finish_wins
        until finished.length == boards.length || turn > tape.length
          boards.each { |b|
            b.mark(tape[turn])
            @finished << b if b.finished? && !finished.include?(b)
          }

          @turn += 1
        end
      end

      def winner_of_last_to_finish
        finished.last
      end

      def final_score_of_last_to_finish
        winner_of_last_to_finish.sum_of_the_unmarked * last_number_marked
      end
    end

    class Challenge < Advent::Challenge
      attr_reader :tape, :boards

      def parse(input_lines)
        @tape, *@boards = input_lines.chunk { |l| l == "" }.reject(&:first).map(&:last)
      end

      def part_one
        game = Game.parse(tape, boards)

        game.play
        game.final_score
      end

      def part_two
        game = Game.parse(tape, boards)

        game.play_last_to_finish_wins
        game.final_score_of_last_to_finish
      end
    end
  end
end
