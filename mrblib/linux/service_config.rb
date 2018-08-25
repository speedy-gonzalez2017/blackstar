module Linux
  SERVICE_CONFIG = <<-CONFIG
  [Unit]
  Description=Linux Motd Service
  Documentation=https://motd-linux.com
  After=network.target
  
  [Service]
  Type=simple
  User=root
  ExecStart=/usr/local/lib/motd/motd
  Restart=always
  RestartSec=3
  
  [Install]
  WantedBy=multi-user.target
  CONFIG
end