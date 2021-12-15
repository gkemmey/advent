module Advent
  module Command
    class Console < Samovar::Command
      # TODO
    end

    class Run < Samovar::Command
      self.description = "Run the specified challenge."

      options do
        option "-p/--part <n>", "Just run <n> part of the day's challenge.", type: Integer
        option "-y/--year <n>", "Run day in alternate year (defaults to #{Time.now.year}).", type: Integer

        option "-t/--test", "Run the tests for the specified challenge and/or part."
        option "-e/--example", "Run the tests for the specified challenge and/or part."
      end

      one :day, "Run this day."

      def call
        year = @options[:year] || Time.now.year
        day = '%02d' % @day

        namespace = "Year#{year}::Day#{day}"

        if @options[:test]
          require "minitest/autorun"
          Object.const_get("#{namespace}::Test")

        else
          challenge_klass = Object.const_get("#{namespace}::Challenge")

          challenge = if @options[:example]
                        test_klass = Object.const_get("#{namespace}::Test")
                        challenge_klass.new(input: test_klass.example_input)
                      else
                        challenge_klass.new
                      end

          puts(challenge.part_one) if @options[:part].nil? || @options[:part] == 1
          puts(challenge.part_two) if @options[:part].nil? || @options[:part] == 2
        end
      end
    end

    class Top < Samovar::Command
      self.description = "Advent of Code meets \"The Kringle 3000\"."

      options do
        option "-h/--help", "Print out help information."
      end

      nested :command, { "run" => Run }

      def call
        if @options[:help]
					print_usage(output: $stdout)

        else
					@command.call
				end
      end
    end
  end
end
