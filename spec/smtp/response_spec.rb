require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module SMNP
  describe Response do
    
    def data
      "\x30\x2d\x02\x01\x00\x04\x06\x70\x75\x62\x6c\x69\x63\xa2\x20\x02" +
      "\x04\xff\xff\xff\xff\x02\x01\x00\x02\x01\x00\x30\x12\x30\x10\x06" +
      "\x08\x2b\x06\x01\x02\x01\x04\x03\x00\x41\x04\x04\x97\x3f\x10"
    end
    
    it "should receive data and return the number the IP datagram counter." do
      r = Response.new data
      r.datagram_counter.should == 77020944
    end
        
  end
end