require 'socket'

module SMTP
  class Network
    attr_accessor :sock
    
    def connect(options)
      sock = create_connection(options)
    end
    
    def close
      sock.shutdown
    end
    
    def <<(send_text)
      sock.send send_text, 0
    end
    
    def acknowledge
      code = 0
      begin
        last_line = sock.readline
        code = last_line.split.first.to_i
      end until code > 0 
      code
    end
    
  private
    def create_connection(options)
      TCPSocket.new(options[:host], options[:port])
    end
  end
end