module Advent
  class Challenge
    class << self
      def year
        year, *rest = name.split("::")
        year.split("Year").last
      end

      def day
        year, day, *rest = name.split("::")
        day.split("Day").last
      end

      def input_filename
        "inputs/#{year}/day_#{day}.txt"
      end
    end

    attr_reader :parsed

    def initialize(input: nil)
      @parsed = parse((input || read_input_file).lines(chomp: true))
    end

    def parse(input_lines)
      input_lines
    end

    def read_input_file
      File.read(Advent.root.join(self.class.input_filename))
    end
  end
end
