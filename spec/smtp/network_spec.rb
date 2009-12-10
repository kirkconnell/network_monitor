require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module SMTP
  describe Network do
    before(:all) do
      @network = Network.new
    end
    
    def network
      @network
    end
    
    describe "just created" do
      it "should connect to a host" do
        TCPSocket.should_receive(:new).with("mail.ksu.edu", 25)
        network.connect(:host => "mail.ksu.edu", :port => 25)
      end
    end

    describe "with a live connection" do
      before(:all) do
        @network.sock = mock("socket", 
                              { :send => true,
                                :shutdown => true})
      end
      
      it "should close connection" do
        network.sock.should_receive(:shutdown)
        network.close
      end
    
      it "should send text" do
        network.sock.should_receive(:send).with("Line of Text!", 0).and_return(true)
        network << "Line of Text!"
      end
      
      it "should find the acknowledge code in multiline responses" do
        @response = "Connected to mailhost.ksu.edu.\r\nEscape character is '^]'.\r\n220 smtp3....>"
        network.acknowledge.should == 220
      end
      
      it "should find the acknowledge code in singleline responses" do
        @response = "250 2.1.0 <neilsen@ksu.edu>... Sender ok\r\n"
        network.acknowledge.should == 250
      end
    
    end    
  end
end
