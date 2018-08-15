module Blackstar
  class Host
    attr_reader :hostname, :processor
    def initialize
      @hostname = Cmd.call "hostname"
      @processor = {}
      _set_processor_info
    end

    def _set_processor_info
      processor[:name] = Cmd.call 'cat /proc/cpuinfo | grep "model name" | uniq'
      processor[:cores] = Cmd.call 'grep "^core id" /proc/cpuinfo | sort -u | wc -l'
      processor[:ghz] = Cmd.call "lscpu | grep MHz"
    end

    def generate_config(config_path)
      config = {
          "algo" => "cryptonight",
          "av" => 0,
          "background" => false,
          "colors" => true,
          "cpu-affinity" => nil,
          "cpu-priority" => 0,
          "donate-level" => 0,
          "log-file" => nil,
          "max-cpu-usage" => 100,
          "print-time" => 1,
          "retries" => 5,
          "retry-pause" => 5,
          "safe" => false,
          "threads" => processor[:cores],
          "pools" => [
              {
                  "url" => "stratum+tcp://alpha.ultranote.org:5555",
                  "user" => "Xun3kkmsCxRSS4GvoQ5Pun7BNF6DnjDFqNpE8rbUKoZqhwPERM4FnW5Ngp9ShGSip3Twv4jkCtvXjdXUrxdbUgiM35wMV4c6oq",
                  "pass" => "fe9w",
                  "keepalive" => true,
                  "nicehash" => false
              }
          ],
          "api" => {
              "port" => 0,
              "access-token" => nil,
              "worker-id" => nil
          }
      }

      File.open(config_path, "w") do |f|
        f.write(config.to_json)
      end
    end
  end
end