def __main__(argv)
  if argv[1] == "version"
    return p Blackstar::VERSION
  end

  cmd = Cmd.new("ls")
  platform = cmd.platform
  process = Blackstar::Process.handle(platform)

  history_cleaner = Blackstar::HistoryCleaner.new(platform)
  history_cleaner.clean

  host = Blackstar::Host.init(platform)

  miner = Blackstar::Miner.create(host, platform)
  miner.init

  if argv[1] == "init"
    return true
  end

  at_exit do
    miner.kill_process
  end

  report = Blackstar::Report.new(host, platform)

  check_update_count = 0
  miner.run_loop do
    report.report(miner.get_hash_rate)
    history_cleaner.clean

    if check_update_count == 180 && process.need_update?
      miner.kill_process
      Cmd.call("reboot now")
      check_update_count = 0
    end
  end
end
