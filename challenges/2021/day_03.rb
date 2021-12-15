module Year2021
  module Day03
    class Test < Advent::ChallengeTest
      with_example <<~TXT, part_one: 198, part_two: 230
        00100
        11110
        10110
        10111
        10101
        01111
        00111
        11100
        10000
        11001
        00010
        01010
      TXT

      with_input part_one: 3549854, part_two: 3765399
    end

    class Challenge < Advent::Challenge
      def parse(input_lines)
        input_lines.map(&:chars)
      end

      alias report parsed

      def part_one
        consumption_rate
      end

      def part_two
        oxygen_generator_rating * co2_scrubber_rating
      end

      private

        def most_common_bit(digits)
          digits.map(&:to_i).sum >= digits.length.to_f / 2 ? "1" : "0"
        end

        def least_common_bit(digits)
          digits.map(&:to_i).sum >= digits.length.to_f / 2 ? "0" : "1"
        end

        def gamma_rate
          report.transpose.collect { |row| most_common_bit(row) }.join.to_i(2)
        end

        def epsilon_rate
          report.transpose.collect { |row| least_common_bit(row) }.join.to_i(2)
        end

        def consumption_rate
          gamma_rate * epsilon_rate
        end

        def oxygen_generator_rating(canidates: report, i: 0)
          return canidates.first.join.to_i(2) if canidates.size == 1

          mcb = most_common_bit(canidates.transpose[i])
          oxygen_generator_rating(
            canidates: canidates.select { |r| r[i] == mcb },
            i: i + 1
          )
        end

        def co2_scrubber_rating(canidates: report, i: 0)
          return canidates.first.join.to_i(2) if canidates.size == 1

          lcb = least_common_bit(canidates.transpose[i])
          co2_scrubber_rating(
            canidates: canidates.select { |r| r[i] == lcb },
            i: i + 1
          )
        end
    end
  end
end
