module Blackstar
  class Process
    class << self
      def handle(platform)
        klass = Blackstar::ProcessLinux
        if platform == :win

        end

        klass.new.handle
      end
    end
  end
end