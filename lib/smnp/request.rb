module SMNP
  class Request
    attr_accessor :req_id
    
    def initialize
      self.req_id = random_id
      @before = "\x30\x29\x02\x01\x00\x04\x06\x70\x75\x62\x6C\x69\x63\xA0\x1C\x02" +
                "\x04"
      @after  = "\x02\x01\x00\x02\x01\x00\x30\x0E\x30\x0C\x06" +
                "\x08\x2B\x06\x01\x02\x01\x04\x03\x00\x05\x00"
    end
    
    def random_id()
        chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
        rnd_id = ""
        1.upto(4) { |i| rnd_id << chars[rand(chars.size-1)] }
        return rnd_id
    end
    
    def to_s
      [@before, self.req_id, @after].join
    end
  end
end