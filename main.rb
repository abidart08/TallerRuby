require 'socket'
require 'minitest/autorun'
#Se implementa un servidor TCP en el puerto 5678
server = TCPServer.new("192.168.1.41", 5678)

#CLASES
#Clase MEMCACHED donde se llaman a los metodos segun los comandos ingresados en el servidor y se almacenan los valores
class Memcached
  #Atributos
  @values
  @timeValues
  #Metodo constructor
  def initialize()
    @values = Hash.new("NO VALUE")
    @timeValues = Hash.new()
  end
  #Metodo GET retorna el valor con la clave pasada por parametro
  def get(key)
    if @values[key] != "NO VALUE"
      hora = Time.now.to_s.split()[1].split(":")
      enSegundos = hora[0].to_i*3600+hora[1].to_i*60+hora[2].to_i
      v = @values[key]
      t = @timeValues[key]
      dif = enSegundos.to_i - t.to_i
      expTime = v.getTime().to_i
      if dif > expTime
        v.showValue()
      end
    end
  end
  #Metodo SET se encarga de insetar en el hash una entidad del tipo Value en @values y el momento en que
  #se inserto en @timeValues con la misma clave
  def set(key, flag, time, size, data)
    v = Value.new(key, flag, time, size, data)
    @values[key] = v
    hora = Time.now.to_s.split()[1].split(":")
    enSegundos = hora[0].to_i*3600+hora[1].to_i*60+hora[2].to_i
    @timeValues["key"]=enSegundos
    return "STORED\r\n"
  end

  #Metodo ADD agrega un nuevo valor a @values con una clave correspondiente
  def add(key, flag, time, size, data)
    if (@values[key] <=> "NO VALUE") == 0
      v = Value.new(key, flag, time, size, data)
      @values["key"] = v 
      hora = Time.now.to_s.split()[1].split(":")
      enSegundos = hora[0].to_i*3600+hora[1].to_i*60+hora[2].to_i
      @timeValues["key"]=enSegundos
      return "STORED\r\n"
    end
    return "ERROR\r\n"
  end
  #Metodo REPLACE remplaza un valor de @values con la clave pasada por parametro
  def replace(key, flag, time, size, data)
    if (@values[key] <=> "NO VALUE" )!= 0
      v = Value.new(key, flag, time, size, data)
      @values["key"] = v 
      hora = Time.now.to_s.split()[1].split(":")
      enSegundos = hora[0].to_i*3600+hora[1].to_i*60+hora[2].to_i
      @timeValues["key"]=enSegundos
      return "STORED\r\n"
    end
    return "ERROR\r\n"
  end
  #Metodo APPEND que agrega un nuevo valor al final de uno ya existente con esa misma clave pasada por parametro
  def append(key, flag, time, size, data)
    keyValor = @values[key]
    v = Value.new(key, flag, time ,size.to_i + keyValor.getSize().to_i, keyValor.getData().to_s + data.to_s)
    @values[key] = v
    return "STORED\r\n"
  end
  #Metodo PREPEND agrega un nuevo valor al comienzo de uno ya existente con esa misma clave pasada por parametro
  def prepend(key, flag, time, size, data)
    keyValor = @values[key]
    v = Value.new(key, flag, time ,size.to_i + keyValor.getSize().to_i, data.to_s + keyValor.getData().to_s)
    @values[key] = v
    return "STORED\r\n"
  end

  def gets(key)
    #@values.each_value {|value| value.showValue} 
    if @values[key] != "NO VALUE"
        v.showValue()
    end
  end

  def cas(key, flag, time, size, cas, data)
    #v = Value.new(key, flag, time, size, data) cas...
    #@values[key] = v
    #return "STORED\r\n"
  end

end
#Clase VALUE donde se crean las entidades a almacenar en Memcached 
class Value
  #Atributos
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

  def getKey() return @key end
  def getFlag() return @flag end
  def getTime() return @time end
  def getSize() return @size end
  def getData() return @data end

  #Imprime los valores que memcached muestra al solicitarle un valor por medio de get
  #Retorna los valores a mostrar en pantalla con el formato de Memcached
  def showValue()
    return "VALUE " + getKey().to_s + " " + getFlag().to_s + " " + getSize().to_s + "\r\n" + getData().to_s + "\r\n"
  end
end

#Main

m = Memcached.new()
while session = server.accept
  session.print "Welcome to Memcached \r\n"
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
      session.print m.set(key,flag,time,size,value)
      #session.print "STORED\r\n"
      info = session.gets.chomp.strip()
    elsif command == "get"
      key = infoSplit[1]
      session.print m.get(key).to_s
      session.print "END\r\n"
      info = session.gets.chomp.strip()
    elsif command == "add"
      key = infoSplit[1]
      flag = infoSplit[2]
      time = infoSplit[3]
      size = infoSplit[4]
      value = session.gets.chomp.strip()
      session.print m.add(key,flag,time,size,value)
      #session.print "STORED\r\n"
      info = session.gets.chomp.strip()
    elsif command == "append"
      key = infoSplit[1]
      flag = infoSplit[2]
      time = infoSplit[3]
      size = infoSplit[4]
      value = session.gets.chomp.strip()
      session.print m.append(key,flag,time,size,value)
      #session.print "STORED\r\n"
      info = session.gets.chomp.strip()
    elsif command == "prepend"
      key = infoSplit[1]
      flag = infoSplit[2]
      time = infoSplit[3]
      size = infoSplit[4]
      value = session.gets.chomp.strip()
      session.print m.prepend(key,flag,time,size,value)
      #session.print "STORED\r\n"
      info = session.gets.chomp.strip()
    elsif command == "replace"
      key = infoSplit[1]
      flag = infoSplit[2]
      time = infoSplit[3]
      size = infoSplit[4]
      value = session.gets.chomp.strip()
      session.print m.replace(key,flag,time,size,value)
      #session.print "STORED\r\n"
      info = session.gets.chomp.strip()
    else
      session.print "ERROR\r\n"
      info = session.gets.chomp.strip()
    end
  end
  session.close
end

#TESTS

class TestMemcached < Minitest::Unit::TestCase
  #Inicializo un objeto del tipo Memcached
  def setup
    @memcached = Memcached.new
  end
  #Tests SET
  def testSetWorking
    assert_equal "STORED\r\n", @memcached.set("foo", 0, 1000, 2, 56)
  end
  #Tests GETS
  def testGetWorking
    @memcached.set("foo", 0, 1000, 2, 56)
    assert_equal "VALUE foo 0 + 2" + "\r\n" + "56" + "\r\n" , @memcached.get("foo")
  end

  def testGetNotWorking
    assert_equal nil, @memcached.get("foo")
  end
  #Tests PREPEND
  def testPrependWorking
    @memcached.set("foo", 0, 1000, 2, 56)
    assert_equal "STORED\r\n", @memcached.prepend("foo", 0, 1000, 2, 88)
  end

  def testPrependNotWorking
    assert_equal nil, @memcached.prepend("foo", 0, 1000, 2, 56)
  end

  #Tests APPEND
  def testAppendWorking
    @memcached.set("foo", 0, 1000, 2, 56)
    assert_equal "STORED\r\n", @memcached.append("foo", 0, 1000, 2, 77)
  end

  def testAppendNotWorking
    assert_equal nil, @memcached.append("foo", 0, 1000, 2, 77)
  end

  #Tests ADD
  def testAddWorking
    assert_equal "STORED\r\n", @memcached.add("foo", 0, 1000, 2, 33)
  end

  def testAddNotWorking
    @memcached.set("foo", 0, 1000, 2, 56)
    assert_equal nil, @memcached.add("foo", 0, 1000, 2, 33)
  end

  #Test REPLACE
  def testReplaceWorking
    @memcached.set("foo", 0, 1000, 2, 56)
    assert_equal "STORED\r\n", @memcached.replace("foo", 0, 1000, 2, 56)
  end

  def testReplaceNotWorking
    assert_equal nil, @memcached.replace("foo", 0, 1000, 2, 33)
  end

end


