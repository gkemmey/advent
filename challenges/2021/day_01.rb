module Year2021
  module Day01
    class Test < Advent::ChallengeTest
      with_example <<~TXT, part_one: 7, part_two: 5
        199
        200
        208
        210
        200
        207
        240
        269
        260
        263
      TXT

      with_input part_one: 1502, part_two: 1538
    end

    class Challenge < Advent::Challenge
      def parse(input_lines)
        input_lines.map(&:to_i)
      end

      alias measurements parsed

      def part_one
        1.upto(measurements.length - 1).count { |i| measurements[i] > measurements[i - 1] }
      end

      def part_two
        windows = 0.upto(measurements.length - 3).each_with_object([]) { |i, memo|
                    memo << measurements[i...(i + 3)]
                  }
        1.upto(windows.length - 1).count { |i| windows[i].sum > windows[i - 1].sum }
      end
    end
  end
end
