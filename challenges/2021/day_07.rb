module Year2021
  module Day07
    class Test < Advent::ChallengeTest
      with_example <<~TXT, part_one: [2, 37], part_two: [5, 168]
        16,1,2,0,4,2,7,1,2,14
      TXT

      with_input part_one: [316, 336721], part_two: [466, 91638945]
    end

    class Challenge < Advent::Challenge
      def parse(input_lines)
        input_lines.flat_map { |l| l.split(",").map(&:to_i) }
      end

      alias levels parsed

      Solution = Struct.new(:level, :fuel_cost)

      def part_one
        candidate_levels.collect { |target|
          Solution.new(target, levels.collect { |l| (l - target).abs }.sum)
        }.min_by(&:fuel_cost).to_a
      end

      def part_two
        candidate_levels.collect { |target|
          Solution.new(
            target,
            levels.collect { |l| sum_of_consecutive_integers_upto((l - target).abs) }.sum
          )
        }.min_by(&:fuel_cost).to_a
      end

      def candidate_levels
        0.upto(levels.max)
      end

      def sum_of_consecutive_integers_upto(n)
        ((1 + n) / 2.0 * n).to_i
      end
    end
  end
end
