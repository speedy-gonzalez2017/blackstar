class Cmd
  @@platform = false
  @@out_file = false
  attr_reader :cmd

  def initialize(cmd)
    @cmd = cmd
  end

  def out_file
    @@out_file ||= File.join(Dir.getwd, "out")
  end

  def platform
    return @@platform if @@platform
    result = call_win("ls")
    if result ==  ""
      @@platform = :win
    else
      @@platform = :linux
    end
  end

  def call
    if platform == :win
      return call_win(cmd)
    end

    if platform == :linux
      return call_linux(cmd)
    end
  end

  def call_win(cmd)
    system("#{cmd} > #{out_file}")
    result = File.read(out_file)
    File.delete(out_file)
    result
  end

  def call_linux(cmd)
    `#{cmd}`.split.join(' ')
  end


  class << self
    def platform
      @@platform
    end

    def call(cmd)
      new(cmd).call
    end

    def call_forked(cmd)
      if platform == :win
        system(cmd)
      elsif platform == :linux
        Process.fork do
          new(cmd).call
        end
      end
    end
  end
end