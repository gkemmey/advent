module Year2021
  module Day02
    class Test < Advent::ChallengeTest
      with_example <<~TXT, part_one: 150, part_two: 900
        forward 5
        down 5
        forward 8
        up 3
        down 8
        forward 2
      TXT

      with_input part_one: 1813801, part_two: 1960569556
    end

    class Position_OLD
      def initialize
        @depth, @x = 0, 0
      end

      def move(line)
        direction, amount = line.split(" ")
        send("move_#{direction}", amount.to_i)
      end

      def move_forward(amount); @x += amount; end

      def move_down(amount); @depth += amount; end
      def move_up(amount);   @depth -= amount; end

      def multiply
        @depth * @x
      end
    end

    class Position
      def initialize
        @depth, @x, @aim = 0, 0, 0
      end

      def move(line)
        direction, amount = line.split(" ")
        send("move_#{direction}", amount.to_i)
      end

      def move_forward(amount); @x += amount; @depth += amount * @aim end

      def move_down(amount); @aim += amount; end
      def move_up(amount);   @aim -= amount; end

      def multiply
        @depth * @x
      end
    end

    class Challenge < Advent::Challenge
      alias lines parsed

      def part_one
        lines.each_with_object(Position_OLD.new) { |l, position| position.move(l) }.multiply
      end

      def part_two
        lines.each_with_object(Position.new) { |l, position| position.move(l) }.multiply
      end
    end
  end
end
