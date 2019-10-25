require 'socket'
server = TCPServer.new("192.168.1.48", 5678)

while session = server.accept
  request = session.gets
  puts request
  session.print "Hello world! The time is #{Time.now}" 
  session.close
end
