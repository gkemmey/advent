module Year2021
  module Day09
    class Test < Advent::ChallengeTest
      with_example <<~TXT, part_one: 15, part_two: 1134
        2199943210
        3987894921
        9856789892
        8767896789
        9899965678
      TXT

      with_input part_one: 516, part_two: 1023660
    end

    class Challenge < Advent::Challenge
      class HeightMap
        class Basin < Struct.new(:size); end

        class Point
          attr_reader :x, :y, :height_map

          def initialize(x, y, height_map)
            @x, @y, @height_map = x, y, height_map
          end

          def low?
            adjacent_points.none? { |ap| ap.height <= height }
          end

          def height
            height_map[x][y]
          end

          def risk_level
            height + 1
          end

          def adjacent_points
            [].tap { |memo|
              memo << [x, y - 1] if y > 0
              memo << [x + 1, y] if x < height_map.max_x
              memo << [x, y + 1] if y < height_map.max_y
              memo << [x - 1, y] if x > 0
            }.
              collect { |(x, y)| Point.new(x, y, height_map) }
          end

          def hash
            [x, y, height_map].hash
          end

          def eql?(other)
            return false unless self.class === other
            x.eql?(other.x) && y.eql?(other.y) && height_map.eql?(other.height_map)
          end
          alias == eql?
        end

        include Enumerable

        def initialize(readings)
          @readings = readings
        end

        def each(&block)
          @readings.each.with_index { |row, x|
            row.each.with_index { |_, y|
              block.call(Point.new(x, y, self))
            }
          }
        end

        def max_x
          @readings.length - 1
        end

        def max_y
          @readings.first.length - 1
        end

        def [](index)
          @readings[index]
        end

        def basins
          self.select { |point| point.low? }.collect { |low_point|
            Basin.new(search_for_basin_points(low_point).size)
          }
        end

        private

          def search_for_basin_points(point, already_checked = [])
            return [] if already_checked.include?(point)
            already_checked << point # note: purposefully mutating this array so recursive calls know what's been searched

            search_next = point.adjacent_points.select { |p| p.height < 9 }
            [point] + search_next.flat_map { |_next| search_for_basin_points(_next, already_checked) }
          end
      end

      def parse(input_lines)
        input_lines.map { |l| l.chars.map(&:to_i) }
      end

      alias readings parsed

      def part_one
        HeightMap.new(readings).select { |point| point.low? }.sum(&:risk_level)
      end

      def part_two
        HeightMap.new(readings).basins.sort_by(&:size).last(3).reduce(1) { |memo, b| memo * b.size }
      end
    end
  end
end
