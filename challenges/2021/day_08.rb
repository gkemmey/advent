module Year2021
  module Day08
    class Test < Advent::ChallengeTest
      with_example <<~TXT, part_one: 26, part_two: 61229
        be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
        edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
        fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
        fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
        aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
        fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
        dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
        bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
        egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
        gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
      TXT

      with_input part_one: 303, part_two: 961734
    end

    class Challenge < Advent::Challenge
      class Reading < Struct.new(:digits, :output); end

      class SevenSegmentDisplay
        STANDARD_MAPPING = %w(a b c d e f g).then { |segments| segments.zip(segments).to_h }
        DIGITS = {
          %w(a b c e f g)   => 0,
          %w(c f)           => 1,
          %w(a c d e g)     => 2,
          %w(a c d f g)     => 3,
          %w(b c d f)       => 4,
          %w(a b d f g)     => 5,
          %w(a b d e f g)   => 6,
          %w(a c f)         => 7,
          %w(a b c d e f g) => 8,
          %w(a b c d f g)   => 9
        }

        def initialize(on_segments, mapping = STANDARD_MAPPING)
          @on_segments = on_segments
          @mapping = mapping

          @value = DIGITS[on_segments.chars.map { |s| mapping[s] }.sort]
        end

        def to_i
          @value
        end

        def self.determine_mapping(digits)
          mapping = {}

          one = digits.find { |segments| segments.size == 2 }
          mapping["c"], mapping["f"] = one.chars.minmax_by { |c| digits.count { |s| s.include?(c) } }

          seven = digits.find { |segments| segments.size == 3 }
          mapping["a"] = (seven.chars - mapping.values).first

          four = digits.find { |segments| segments.size == 4 }
          mapping["b"], mapping["d"] = (four.chars - one.chars).minmax_by { |c| digits.count { |s| s.include?(c) } }

          eight = digits.find { |segments| segments.size == 7 }
          mapping["e"], mapping["g"] = (eight.chars - mapping.values).minmax_by { |c| digits.count { |s| s.include?(c) } }

          mapping.invert # we mapped standard => to ours. ultimately, we want ours => standard.
        end
      end

      def parse(input_lines)
        input_lines.collect { |l|
          l.split(" | ").then { |lhs, rhs|
             Reading.new(lhs.split(" "), rhs.split(" "))
          }
        }
      end

      alias readings parsed

      def part_one
        readings.collect { |r| r.output.count { |o| [2, 4, 3, 7].include?(o.size) } }.sum
      end

      def part_two
        readings.collect { |r|
          mapping = SevenSegmentDisplay.determine_mapping(r.digits)

          r.output.collect { |segments|
            SevenSegmentDisplay.new(segments, mapping).to_i
          }.join.to_i
        }.sum
      end
    end
  end
end

__END__

0:      1:      2:      3:      4:
aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
gggg    ....    gggg    gggg    ....

 5:      6:      7:      8:      9:
aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
gggg    gggg    ....    gggg    gggg
