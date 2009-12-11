require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module SMNP
  describe Request do
    
    before(:each) do
      @request = Request.new
    end
    
    def request
      @request
    end
    
    it "should allow to set a request id" do
      request.req_id = "ABCD"
      request.req_id.should == "ABCD"
    end
    
    it "should have a random request id if no request id is specified" do
      request.req_id.length.should == 4
    end
    
    it "should generate an snmp request sring" do
      request.req_id = "\xAA\xAA\xAA\xAA"
      request.to_s.should ==  "\x30\x29\x02\x01\x00\x04\x06\x70\x75\x62\x6C\x69\x63\xA0\x1C\x02" +
                              "\x04\xAA\xAA\xAA\xAA\x02\x01\x00\x02\x01\x00\x30\x0E\x30\x0C\x06" +
                              "\x08\x2B\x06\x01\x02\x01\x04\x03\x00\x05\x00"
    end
    
  end
end