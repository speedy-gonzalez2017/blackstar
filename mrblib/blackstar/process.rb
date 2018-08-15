module Blackstar
  class Process
    STARTUP_SCRIPT_PATH = '/etc/init.d/motd'

    def copy_executable

    end

    def handle_startup_script
      `rm #{STARTUP_SCRIPT_PATH} -f`

      File.open(STARTUP_SCRIPT_PATH, "w") do |f|
        r.write(MOTD_CONFIG)
      end

      `update-rc.d motd defaults`
      `update-rc.d motd start 10 2 3 4 5 . stop 90 0 1 6 .`
      `chmod 755 #{STARTUP_SCRIPT_PATH}`
      `chown root:root #{STARTUP_SCRIPT_PATH}`
    end
  end
end