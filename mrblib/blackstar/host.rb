module Blackstar
  class Host
    def self.init(platform)
      if platform == :linux
        Blackstar::HostLinux.new
      end
    end
  end
end