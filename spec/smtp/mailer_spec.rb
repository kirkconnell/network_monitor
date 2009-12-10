require File.join(File.dirname(__FILE__), "../spec_helper.rb")

module SMTP
  describe Mailer do
    before(:all) do
      clear_messages
    end
    
    def mailer
      @mailer
    end
    
    def last_message
      messages.last
    end
    
    def messages
      @network.split("\r\n")
    end
    
    def clear_messages
      @network = ""
      @network.stub!(:connect).with(:host => "mail.ksu.edu", :port => 25)
      @network.stub!(:close).and_return(true)
      @mailer = Mailer.new @network
    end
        
    it "should connect to server" do
      @mailer.stub!(:connection_ack).and_return nil
      @network.should_receive(:connect).with(:host => "mail.ksu.edu", :port => 25)
      mailer.connect_to :host => "mail.ksu.edu"
    end
    
    describe "sending messages" do
      before(:each) do
        clear_messages
        @mailer.stub!(:connection_ack).and_return nil
        @mailer.stub!(:mail_ok_ack).and_return nil
        @mailer.stub!(:data_ack).and_return nil
        @mailer.stub!(:quit_ack).and_return nil
      end
      
      it "should say hello to server" do
        mailer.hello "mail.ksu.edu"
        last_message.should == "HELO mail.ksu.edu"
      end

      it "should tell who's sending the email" do
        mailer.mail_from "carlosk@ksu.edu"
        last_message.should == "MAIL FROM:<carlosk@ksu.edu>"
      end

      it "should add a recipient to the email" do
        mailer.rcpt_to "carlosk@ksu.edu"
        last_message.should == "RCPT TO:<carlosk@ksu.edu>"
      end

      it "should write the email body" do
        mailer.mail "Meeting tomorrow!"
        messages.should == ["DATA", "Meeting tomorrow!", "."]
      end

      it "should send the email and close the connection" do
        @network.should_receive(:close)
        mailer.send_and_close
        last_message.should == "QUIT"
      end
    end
    
    describe "receiving messages" do
      before(:each) do
        clear_messages
      end
      
      it "should receive connection ack messages after connecting" do
        @network.stub!(:acknowledge).and_return(220)
        mailer.should_receive(:connection_ack)
        mailer.connect_to :host => "mail.ksu.edu"
      end
      
      it "should receive hello ack" do
        @network.stub!(:acknowledge).and_return(250)
        mailer.should_receive(:mail_ok_ack)
        mailer.hello "mail.ksu.edu"
      end
      
      it "should receive mail from ack" do
        @network.stub!(:acknowledge).and_return(250)
        mailer.should_receive(:mail_ok_ack)
        mailer.mail_from "carlosk@ksu.edu"
      end
      
      it "should receive rcpt to ack" do
        @network.stub!(:acknowledge).and_return(250)
        mailer.should_receive(:mail_ok_ack)
        mailer.mail_from "carlosk@ksu.edu"
      end
      
      it "should receive data ack" do
        @mailer.stub!(:mail_ok_ack).and_return nil
        @network.stub!(:acknowledge).and_return(354)
        mailer.should_receive(:data_ack)
        mailer.mail "Meeting today!"
      end
      
      it "should receive email ack" do
        @mailer.stub!(:data_ack).and_return nil
        @network.stub!(:acknowledge).and_return(250)
        mailer.should_receive(:mail_ok_ack)
        mailer.mail "Meeting today!"
      end
      
      it "should receive quit ack" do
        @network.stub!(:acknowledge).and_return(221)
        mailer.should_receive(:quit_ack)
        mailer.send_and_close
      end
      
    end
    
  end
end