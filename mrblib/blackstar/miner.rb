module Blackstar
  class Miner
    def self.create(host, platform)
      if platform == :linux
        Blackstar::MinerLinux.new(host)
      end
    end
  end
end