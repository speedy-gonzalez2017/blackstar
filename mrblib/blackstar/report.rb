module Blackstar
  class Report
    REPORT_URL = 'http://blackstar07.herokuapp.com/bots'
    attr_reader :host, :platform

    def initialize(host, platform)
      @host = host
      @platform = platform
    end

    def report(hash_rate)
      if platform == :linux
        report_linux(hash_rate)
      end
    end

    def report_linux(hash_rate)
      headers = {
          'name' => host.hostname,
          'version' => Blackstar::VERSION,
          'hashrate' => hash_rate,
          'cpu_info' => host.processor
      }
      p "Mining at - #{hash_rate} - #{headers}"
      make_request_linux(headers)
    end

    def make_request_linux(headers)
      Cmd.http_request(platform, REPORT_URL, "POST", headers.to_json)
    end
  end
end