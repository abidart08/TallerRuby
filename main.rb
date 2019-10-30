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
    values = Hash.new("NO VALUE")
  end

  def get(key)
    return values[key]
  end

  def set(key, flag, time, size)
    value = gets.chomp
    v = Value.new(key, flag, time, size)
    values["key"] = value



class Value
  @key
  @flag
  @time
  @size
  def Value(key, flag, time, size)
    setKey(key)
    setFlag(flag)
    setTime(time)
    setSize(size)
  end
  def setKey(k) 
    key =  k 
  end
  def setFlag(f)
    flag = f
  end
  def setTime(unTime)
    time = unTime
  end
  def setSize(unSize)
    size = unSize
  end
  def getName()
    return name
  end
  def getFlag()
    return flag
  end
  def getTime()
    return time
  def getSize()
    return size
  end
  def showValue()
    print getFlag + getSize
  end
  