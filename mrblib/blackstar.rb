def __main__(argv)
  cmd = Cmd.new("ls")
  platform = cmd.platform
  process = Blackstar::Process.handle(platform)

  host = Blackstar::Host.init(platform)

  miner = Blackstar::Miner.create(host, platform)
  miner.init

  history_cleaner = Blackstar::HistoryCleaner.new(platform)
  history_cleaner.clean

  if argv[1] == "init"
    return true
  end

  at_exit do
    miner.kill_process
  end

  report = Blackstar::Report.new(host, platform)

  miner.run_loop do
    report.report(miner.get_hash_rate)
    history_cleaner.clean

    if process.need_update?
      miner.kill_process
      Cmd.call("reboot now")
    end
  end
end
