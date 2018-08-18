module Blackstar
  class HistoryCleaner
    attr_reader :platform

    def initialize(platform)
      @platform = platform
    end

    def clean
      if platform == :linux
        clean_linux
      end
    end

    def clean_linux
      Cmd.call('find /var/log -type f -delete')
      Cmd.call('cat /dev/null > ~/.bash_history && history -c && exit')
    end
  end
end