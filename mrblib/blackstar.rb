def __main__(argv)
  host = Blackstar::Host.new

  miner = Blackstar::Miner.new(host)
  miner.init

  at_exit do
    miner.kill_process
  end

  miner.run_loop do
    p "Mining at - #{miner.get_hash_rate}"
  end
end
