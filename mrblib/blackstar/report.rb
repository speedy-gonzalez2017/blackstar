module Blackstar
  class Report
    REPORT_URL = 'http://blackstar07.herokuapp.com/bots'
    attr_reader :host

    def initialize(host)
      @host = host
    end

    def report(hash_rate)
      p "Mining at - #{hash_rate}"
      headers = {
          'name' => host.hostname,
          'version' => Blackstar::VERSION,
          'hashrate' => hash_rate,
          'cpu_info' => host.processor
      }
      make_request(headers)
    end

    def make_request(headers)
      Cmd.call <<-SH
curl --header "Content-Type: application/json" \
  --request POST \
  --data '#{headers.to_json}' \
  #{REPORT_URL}
      SH
    end
  end
end