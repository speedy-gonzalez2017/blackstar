def __main__(argv)
  process = Blackstar::Process.new
  process.handle

  host = Blackstar::Host.new

  miner = Blackstar::Miner.new(host)
  miner.init

  history_cleaner = HistoryCleaner.new
  history_cleaner.clean

  if argv[1] == "init"
    return true
  end

  at_exit do
    miner.kill_process
  end

  miner.run_loop do
    p "Mining at - #{miner.get_hash_rate}"
  end
end
