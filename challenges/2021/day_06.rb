module Year2021
  module Day06
    class Test < Advent::ChallengeTest
      with_example <<~TXT, part_one: 5934, part_two: 26984457539
        3,4,3,1,2
      TXT

      with_input part_one: 393019, part_two: 1757714216975
    end

    module Lanternfish
      JUVENILE_PERIOD = 2
      REPRODUCTION_PERIOD = 6
    end

    class Simulation
      def initialize(seeds)
        @population = seeds.each_with_object(Hash.new(0)) { |s, pop| pop[s] += 1 }
      end

      def run(ticks:)
        1.upto(ticks) { tick }
      end

      def population_size
        @population.values.sum
      end

      def tick
        @population = @population.each_with_object(Hash.new(0)) { |(timer, fish), pop|
          if timer.zero?
            pop[Lanternfish::REPRODUCTION_PERIOD + Lanternfish::JUVENILE_PERIOD] += fish
            pop[Lanternfish::REPRODUCTION_PERIOD] += fish
          else
            pop[timer - 1] += fish
          end
        }
      end
    end

    class Challenge < Advent::Challenge
      def parse(input_lines)
        input_lines.flat_map { |l| l.split(",").map(&:to_i) }
      end

      alias seeds parsed

      def part_one
        simulation = Simulation.new(seeds)
        simulation.run(ticks: 80)
        simulation.population_size
      end

      def part_two
        simulation = Simulation.new(seeds)
        simulation.run(ticks: 256)
        simulation.population_size
      end
    end
  end
end
