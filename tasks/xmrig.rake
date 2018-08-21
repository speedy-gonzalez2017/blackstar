desc "Buids XMR Miner"
task :build_miner do
  sh "sudo apt-get install git build-essential cmake libuv1-dev libmicrohttpd-dev -y"
  sh "sudo rm ./xmrig -rf"
  sh "sudo git clone https://github.com/xmrig/xmrig.git"
  sh "sudo mkdir -p xmrig/build"

  p "update xmrig/src/donate.h"
  STDIN.gets

  sh "cd xmrig/build && cmake .. -DUV_LIBRARY=/usr/lib/x86_64-linux-gnu/libuv.a -DWITH_HTTPD=OFF && make"
end