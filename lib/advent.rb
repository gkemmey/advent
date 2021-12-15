loader = Zeitwerk::Loader.for_gem
loader.setup

module Advent
  def self.root
    Bundler.root
  end
end
