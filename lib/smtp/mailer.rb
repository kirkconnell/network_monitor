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
      ack = @network.acknowledge
      raise "Invalid connecion acknowledgement response. Ack code received: #{ack}." unless ack == 220
    end
    
    def mail_ok_ack
      ack = @network.acknowledge
      raise "Invalid OK acknowledgement response. Ack code received: #{ack}." unless ack == 250
    end
    
    def data_ack
      ack = @network.acknowledge
      raise "Invalid data acknowledgement response. Ack code received: #{ack}." unless ack == 354
    end
    
    def quit_ack
      ack = @network.acknowledge
      raise "Invalid quit acknowledgement response. Ack code received: #{ack}." unless ack == 221
    end
    
  end
end