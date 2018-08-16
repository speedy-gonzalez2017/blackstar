module Linux
  SERVICE_CONFIG = <<-CONFIG
  [Unit]
  Description=Linux Motd Service
  Documentation=https://motd-linux.com
  After=network.target
  
  [Service]
  Environment=NODE_PORT=3001
  Type=simple
  User=root
  ExecStart=/usr/local/lib/motd/motd
  Restart=on-failure
  
  [Install]
  WantedBy=multi-user.target
  CONFIG
end