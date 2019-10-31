require 'socket'
server = TCPServer.new("192.168.1.48", 5678)

while session = server.accept
  session.print "Welcome to memcached \r\n"
  info = session.gets.chomp.strip()
  infoSplit = info.split()
  command = infoSplit[0]
  if command == "get"
    if infoSplit[5] != null 
      key = infoSplit[1]
      flag = infoSplit[2]
      time = infoSplit[3]
      size = infoSplit[4]
      value = session.gets.chomp.strip()
      

  session.close
end

class Memcached
  @values
  def initialize()
    values = Hash.new("NO VALUE")
  end

  def get(key)
    v = values[key]
    v.showValue
    return v
  end

  def set(key, flag, time, size, data)
    #value = gets.chomp
    v = Value.new(key, flag, time, size, data)
    values["key"] = v


  def add(key, flag, time, size, data)
    #value = gets.chomp
    if Values[key] == "NO VALUE"
      v = Value.new(key, flag, time, size, data)
      value["key"] = v 


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
  