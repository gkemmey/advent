module Year2021
  module Day05
    class Test < Advent::ChallengeTest
      with_example <<~TXT, part_one: 5, part_two: 12
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
      TXT

      with_input part_one: 7644, part_two: 18627
    end

    class Map
      def initialize
        @map = Hash.new(0)
      end

      def plot(vent)
        vent.coordinates.each do |x, y|
          @map[[x, y]] += 1
        end
      end

      def overlaps(gteq:)
        @map.values.count { |v| v >= gteq }
      end
    end

    class Vent
      attr_reader :x1, :y1, :x2, :y2

      def initialize(x1, y1, x2, y2)
        @x1, @y1, @x2, @y2 = x1, y1, x2, y2
      end

      def diagonal?
        x1 != x2 && y1 != y2
      end

      def coordinates
        if x1 == x2
          (y1 < y2 ? y1..y2 : y2..y1).to_a.collect { |y| [x1, y] }
        elsif y1 == y2
          (x1 < x2 ? x1..x2 : x2..x1).to_a.collect { |x| [x, y1] }
        else
          slope = (y2 - y1) / (x2 - x1)

          if x1 < x2
            x1.upto(x2).to_a.collect.with_index { |x, i| [x, y1 + i * slope] }
          else
            x2.upto(x1).to_a.collect.with_index { |x, i| [x, y2 + i * slope] }
          end
        end
      end
    end

    class Challenge < Advent::Challenge
      def parse(input_lines)
        input_lines.collect { |l| Vent.new(*l.scanf("%d,%d -> %d,%d")) }
      end

      alias vents parsed

      def part_one
        map = Map.new
        vents.each { |v| map.plot(v) unless v.diagonal? }
        map.overlaps(gteq: 2)
      end

      def part_two
        map = Map.new
        vents.each { |v| map.plot(v) }
        map.overlaps(gteq: 2)
      end
    end
  end
end
