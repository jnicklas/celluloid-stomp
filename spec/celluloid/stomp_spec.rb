require "celluloid/stomp"

class TestActor
  include Celluloid::Stomp

  attr_reader :messages

  def initialize
    @messages = []
  end

  def parse(io)
    parser = Parser.new(io)
    loop do
      frame = parser.next
      puts "----"
      p frame
      @messages << frame.command
    end
  end
end

RSpec.configure do |config|
  config.around do |ex|
    Celluloid.boot
    ex.run
    Celluloid.shutdown
  end
end

describe Celluloid::Stomp do
  # There is no TCPSocket.pair :(
  let(:sockets) do
    server = TCPServer.new("127.0.0.1", 0)
    client = Thread.new { TCPSocket.new("127.0.0.1", server.addr[1]) }
    [server.accept, client.value]
  end

  let(:write_io) { sockets[0] }
  let(:read_io) { Celluloid::IO::TCPSocket.new(sockets[1]) }

  it "feeds messages" do
    actor = TestActor.new
    actor.async.parse(read_io)
    actor.messages.should be_empty
    write_io.write("SEND\n\n\0")
    sleep 1
    actor.messages.should == ["SEND"]
  end
end
