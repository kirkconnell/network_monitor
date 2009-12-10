module SMTP
  class Mailer
    def initialize(network)
      @network = network
    end
    
    def connect_to(options)
      options[:port] ||= 25
      @network.connect options
      connection_ack
    end
    
    def hello(host)
      @network << "HELO #{host}\r\n"
      mail_ok_ack
    end
    
    def mail_from(sender)
      @network << "MAIL FROM:<#{sender}>\r\n"
      mail_ok_ack
    end
    
    def rcpt_to(recipient)
      @network << "RCPT TO:<#{recipient}>\r\n"
      mail_ok_ack
    end
    
    def mail(body)
      @network << "DATA\r\n"
      data_ack
      @network << "#{body}\r\n"
      @network << ".\r\n"
      mail_ok_ack
    end
    
    def send_and_close
      @network << "QUIT\r\n"
      quit_ack
      @network.close
    end
    
    def connection_ack
      raise "Invalid connecion acknowledgement response." unless @network.acknowledge == 220
    end
    
    def mail_ok_ack
      raise "Invalid OK acknowledgement response." unless @network.acknowledge == 250
    end
    
    def data_ack
      raise "Invalid data acknowledgement response." unless @network.acknowledge == 354
    end
    
    def quit_ack
      raise "Invalid quit acknowledgement response." unless @network.acknowledge == 221
    end
    
  end
end