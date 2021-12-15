module Year2021
  module Day11
    class Test < Advent::ChallengeTest
      with_example <<~TXT.chomp, part_one: 1656, part_two: 195
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
      TXT

      def cave
        @cave ||= begin
          octopodes = Challenge.new(input: Year2021::Day11::Test.example_input).seed_octopodes
          Cave.new(octopodes)
        end
      end

      def test_after_one_tick_with_example
        out = <<~TXT.chomp
          6594254334
          3856965822
          6375667284
          7252447257
          7468496589
          5278635756
          3287952832
          7993992245
          5957959665
          6394862637
        TXT

        assert_equal Year2021::Day11::Test.example_input, cave.to_s
        assert_equal out, cave.tick.to_s
      end

      def test_after_two_ticks_with_example
        out = <<~TXT.chomp
          8807476555
          5089087054
          8597889608
          8485769600
          8700908800
          6600088989
          6800005943
          0000007456
          9000000876
          8700006848
        TXT

        assert_equal out, cave.tick(2).to_s
      end

      def test_after_seven_ticks_with_example
        out = <<~TXT.chomp
          6707366222
          4377366333
          4475555827
          3496655709
          3500625609
          3509955566
          3486694453
          8865585555
          4865580644
          4465574644
        TXT

        assert_equal out, cave.tick(7).to_s
      end

      def test_after_fifty_ticks_with_example
        out = <<~TXT.chomp
          9655556447
          4865556805
          4486555690
          4458655580
          4574865570
          5700086566
          6000009887
          8000000533
          6800000633
          5680000538
        TXT

        assert_equal out, cave.tick(50).to_s
      end

      with_input part_one: 1688, part_two: 403
    end

    class Octopus
      attr_reader :energy, :flashes

      def initialize(energy = 0)
        @energy = energy

        @already_flashed = false
        @flashes = 0
      end

      def already_flashed?
        @already_flashed
      end

      def flash
        @flashes += 1
        @energy = 0
        @already_flashed = true
      end

      def inc(reset: false)
        @energy += 1
        @already_flashed = false if reset
      end

      def ready_to_flash?
        @energy > 9 && !already_flashed?
      end
    end

    class Cave
      attr_reader :octopodes
      alias octopi octopodes
      alias octopuses octopodes

      def initialize(octopodes)
        @octopodes = Advent::Grid.new(octopodes)
      end

      def tick(times = 1)
        times.times do
          octopodes.each { |octopus| octopus.inc(reset: true) }

          loop do
            ready_to_flash = octopodes.each(coordinates: true).select { |(octopus)| octopus.ready_to_flash? }
            break if ready_to_flash.none?

            ready_to_flash.each do |octopus, (row, column)|
              octopus.flash
              octopodes.adjacent(row, column).reject(&:already_flashed?).each(&:inc)
            end
          end
        end

        self
      end

      def flashes
        octopodes.each.sum(&:flashes)
      end

      def to_s
        octopodes.rows.collect { |row|
          row.collect { |octopus| octopus.energy }.join
        }.join("\n")
      end
    end

    class Challenge < Advent::Challenge
      def seed_octopodes
        parsed.collect { |l| l.chars.map { |energy| Octopus.new(energy.to_i) } }
      end

      def part_one
        Cave.new(seed_octopodes).tick(100).flashes
      end

      def part_two
        cave = Cave.new(seed_octopodes)
        flashes_per_tick = []

        loop do
          flashes_per_tick << cave.tick.flashes
          previous_tick, this_tick = flashes_per_tick.last(2)
          break if this_tick.to_i - previous_tick.to_i == cave.octopodes.size
        end

        flashes_per_tick.size
      end
    end
  end
end
