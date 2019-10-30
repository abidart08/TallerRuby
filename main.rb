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
  def initialize()
    values = Hash.new("NO VALUE")
  end

  def get(key)
    return values[key]
  end

  def set(key, flag, time, size)
    value = gets.chomp
    v = Value.new(key, flag, time, size)
    values["key"] = value

  def add


class Value
  @key
  @flag
  @time
  @size
  @data
  def initialize(key, flag, time, size, data)
    setKey(key)
    setFlag(flag)
    setTime(time)
    setSize(size)
    setData(data)
  end

  def setKey(k) @key =  k end
  def setFlag(f) @flag = f end
  def setTime(t) @time = t end
  def setSize(s) @size = s end
  def setData(d) @data = d end

  def getKey() return @name end
  def getFlag() return @flag end
  def getTime() return @time end
  def getSize() return @size end
  def getData() return @data end

  def showValue()
    print "VALUE" + getKey() + getFlag() + getSize() + \r\n + getData
  end
  