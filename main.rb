require 'socket'
server = TCPServer.new("192.168.1.48", 5678)

while session = server.accept
  request = session.gets
  puts request
  session.print "Hello world! The time is #{Time.now}" 
  session.close
end

class Memcached
  @values
  def Memcached()
    values = Array.new(100)
  end



class Value
  @flag
  @time
  @size
  def Value(flag, time, size)
    setFlag(flag)
    setTime(time)
    setSize(size)
  end
  def setFlag(unFlag)
    flag = unFlag
  end
  def setTime(unTime)
    time = unTime
  end
  def setSize(unSize)
    size = unSize
  end
  def getFlag()
    return flag
  end
  def getTime()
    return time
  def getSize()
    return size
  end
  