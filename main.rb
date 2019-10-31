require 'socket'
#Implemento un servidor TCP en el puerto 5678
server = TCPServer.new("192.168.1.48", 5678)
#Clase 
class Memcached
  @values
  @timeValues
  #Metodo constructor
  def initialize()
    @values = Hash.new("NO VALUE")
    @timeValues = Hash.new()
  end

  def get(key)
    if @values[key] != "NO VALUE"
      hora = Time.now.to_s.split()[1].split(":")
      enSegundos = hora[0].to_i*3600+hora[1].to_i*60+hora[2].to_i
      v = @values[key]
      t = @timeValues[key]
      dif = enSegundos.to_i - t.to_i
      expTime = v.getTime().to_i
      if dif > expTime
        return v.showValue()
      end
    end
  end

  def set(key, flag, time, size, data)
    #value = gets.chomp
    v = Value.new(key, flag, time, size, data)
    @values[key] = v
    hora = Time.now.to_s.split()[1].split(":")
    enSegundos = hora[0].to_i*3600+hora[1].to_i*60+hora[2].to_i
    @timeValues["key"]=enSegundos
  end

  #Agrega un valor 
  def add(key, flag, time, size, data)
    #value = gets.chomp
    if Values[key] == "NO VALUE"
      v = Value.new(key, flag, time, size, data)
      value["key"] = v 
    end
  end

  def replace()
  end

  def append()
  end

  def prepend()
  end

end
#Clase 
class Value
  @key
  @flag
  @time
  @size
  @data
  #Metodo constructor
  def initialize(key, flag, time, size, data)
    setKey(key)
    setFlag(flag)
    setTime(time)
    setSize(size)
    setData(data)
  end
  #Metodos getters y setters de los atributos
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

  #Imprime los valores que memcached muestra al solicitarle un valor por medio de get
  def showValue()
    print "VALUE" + getKey().to_s + getFlag().to_s + getSize().to_s + "\r\n" + getData().to_s
  end
  end

  m = Memcached.new()
  while session = server.accept
    session.print "Welcome to memcached \r\n"
    #m = Memcached.new
    info = session.gets.chomp.strip()
    while info != "exit"
      infoSplit = info.split()
      command = infoSplit[0]
      if command == "set"
        key = infoSplit[1]
        flag = infoSplit[2]
        time = infoSplit[3]
        size = infoSplit[4]
        value = session.gets.chomp.strip()
        m.set(key,flag,time,size,value)
        session.print "STORED\r\n"
        info = session.gets.chomp.strip()
      elsif command == "get"
        key = infoSplit[1]
        session.print m.get(key).to_s
        session.print "END\r\n"
        info = session.gets.chomp.strip()
      else
        session.print "ERROR\r\n"
        info = session.gets.chomp.strip()
      end
    end
    session.close
  end