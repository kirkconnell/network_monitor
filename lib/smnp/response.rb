module SMNP
  class Response
    def initialize(data)
      @data = data
    end
    
    def datagram_counter
      relevant = @data[43..46]
      relevant.unpack('N').first
    end
  end
end