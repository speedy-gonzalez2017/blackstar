module Blackstar
  class HostLinux
    attr_reader :hostname, :processor
    def initialize
      @hostname = Cmd.call "dmidecode -t 4 | grep ID | sed 's/.*ID://;s/ //g'" || Cmd.call("hostname")
      @processor = {}
      _set_processor_info
    end

    def _set_processor_info
      processor[:name] = Cmd.call 'cat /proc/cpuinfo | grep "model name" | uniq'
      processor[:cores] = Cmd.call 'grep -c ^processor /proc/cpuinfo'
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
                  "url" => "stratum+tcp://pool.supportxmr.com:5555",
                  "user" => "46EMhBKvMzSavZjwWJCZgW5VP5dbb7amhaQum2ttwxnqTGUfzztgE4uXoVLDVXoojLiM3rehuPDQq4FtjoFGHPEKQxdoGkf",
                  "pass" => "x",
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