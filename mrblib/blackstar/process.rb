module Blackstar
  class Process
    attr_reader :platform

    def initialize(platform)
      @platform = platform
    end

    def handle
      klass = Blackstar::ProcessLinux
      if platform == :win

      end

      klass.new.handle
    end
  end
end