module Advent
  class ChallengeTest < Minitest::Test
    class << self
      attr_accessor :example_input

      def with_example(input, part_one: nil, part_two: nil)
        self.example_input = input

        define_method "test_part_one_with_example" do
          assert_equal part_one, challenge_klass.new(input: input).part_one
        end unless part_one.nil?

        define_method "test_part_two_with_example" do
          assert_equal part_two, challenge_klass.new(input: input).part_two
        end unless part_two.nil?
      end

      def with_input(part_one: nil, part_two: nil)
        define_method "test_part_one_with_input" do
          assert_equal part_one, challenge_klass.new.part_one
        end unless part_one.nil?

        define_method "test_part_two_with_input" do
          assert_equal part_two, challenge_klass.new.part_two
        end unless part_two.nil?
      end
    end

    attr_reader :challenge_klass

    def setup
      *namespace, test = self.class.name.split("::")
      @challenge_klass = Object.const_get("#{namespace.join("::")}::Challenge")
    end
  end
end
