class Cmd
  @@platform = false
  @@out_file = false
  attr_reader :cmd

  def initialize(cmd=nil)
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
      call_linux(cmd)
    end
  end

  def call_win(cmd)
    p "Calling Windows #{cmd}"
    system("#{cmd} > #{out_file}")
    result = File.read(out_file)
    File.delete(out_file)
    result
  end

  def call_linux(cmd)
    p "Calling Linux# #{cmd}" if ENV["BLACKSTAR_ENV"] == "dev"
    `#{cmd}`.split.join(' ')
  end

  def http_req_linux(url, type, body, output)
    command = "curl -L --silent --header 'Content-Type: application/json' --request #{type} "

    if body
      command += " --data '#{body}' "
    end

    if output
      command += " --output '#{output}' "
    end

    command += url

    call_linux(command)
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

    def http_request(platform, url, type, data=nil, output=nil)
      instance = new

      if platform == :linux
        instance.http_req_linux(url, type, data, output)
      end
    end

    def download_file(platform, saved_location, url)
      http_request(platform, url, "GET", nil, saved_location)
    end
  end
end