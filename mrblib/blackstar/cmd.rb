module Cmd
  def self.call(cmd)
    `#{cmd}`.split.join(' ')
  end

  def self.call_forked(cmd)
    Process.fork do
      `#{cmd}`
    end
  end
end