module Year2021
  module Day10
    class Test < Advent::ChallengeTest
      with_example <<~TXT, part_one: 26397, part_two: 288957
        [({(<(())[]>[[{[]{<()<>>
        [(()[<>])]({[<{<<[]>>(
        {([(<{}[<>[]}>{[]{[(<()>
        (((({<>}<{<{<>}{[]{[]{}
        [[<[([]))<([[{}[[()]]]
        [{[{({}]{}}([{[{{{}}([]
        {<[[]]>}<{[{[{[]{()[[[]
        [<(<(<(<{}))><([]([]()
        <{([([[(<>()){}]>(<<{{
        <{([{{}}[<[[[<>{}]]]>[]]
      TXT

      with_input part_one: 299793, part_two: 3654963618
    end

    module SyntaxChecker
      class GroupingCharacter
        # -------- implementation --------

        def initialize(value = nil, opening: nil, closing: nil, autocomplete_score: 0, error_score: 0)
          @value = value
          @opening = opening
          @closing = closing
          @autocomplete_score = autocomplete_score
          @error_score = error_score
        end

        def opening?; @opening.nil? && !@closing.nil?; end
        def closing?; @closing.nil? && !@opening.nil?; end

        def pair?(other);
          return @closing == other if opening?
          return @opening == other if closing?
          false
        end

        attr_reader :autocomplete_score, :error_score

        # -------- class-level registry of known grouping characters --------

        class << self
          attr_accessor :registry

          def register(opening:, closing:, **kwargs)
            registry[opening] = new(opening, closing: closing, **kwargs).freeze
            registry[closing] = new(closing, opening: opening, **kwargs).freeze
          end

          def call(c)
            registry[c]
          end
        end

        NOT_A_GROUPING_CHARACTER = self.new.freeze
        self.registry = Hash.new(NOT_A_GROUPING_CHARACTER)

        register opening: "(".freeze, closing: ")".freeze, autocomplete_score: 1, error_score:     3
        register opening: "[".freeze, closing: "]".freeze, autocomplete_score: 2, error_score:    57
        register opening: "{".freeze, closing: "}".freeze, autocomplete_score: 3, error_score:  1197
        register opening: "<".freeze, closing: ">".freeze, autocomplete_score: 4, error_score: 25137
      end

      class Line
        def initialize(line)
          @line = line
          @stack = []

          check
        end

        def check
          @index_of_last_valid = @line.chars.take_while { |c|
            next @stack.push(c) if GroupingCharacter.(c).opening?

            if GroupingCharacter.(c).closing?
              GroupingCharacter.(c).pair?(@stack.pop)
            end
          }.length - 1
        end

        def valid?
          @stack.empty? && @index_of_last_valid == @line.length - 1
        end

        def incomplete?
          !valid? && @index_of_last_valid == @line.length - 1
        end

        def error_score
          valid? ? 0 : GroupingCharacter.(@line[@index_of_last_valid + 1]).error_score
        end

        def autocomplete_score
          return 0 if valid?

          @stack.reverse.reduce(0) { |memo, c|
            memo * 5 + GroupingCharacter.(c).autocomplete_score
          }
        end
      end
    end

    class Challenge < Advent::Challenge
      alias lines parsed

      def part_one
        lines.map { |l| SyntaxChecker::Line.new(l) }.reject(&:incomplete?).collect(&:error_score).sum
      end

      def part_two
        lines.map { |l| SyntaxChecker::Line.new(l) }.
          select(&:incomplete?).
          collect(&:autocomplete_score).
          sort.
          then { |scores| scores[scores.length / 2] } # always odd number of incomplete, so that's the middle
      end
    end
  end
end
