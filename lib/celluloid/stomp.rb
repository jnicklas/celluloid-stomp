require "stomp_parser"
require "celluloid/io"
require "celluloid/stomp/version"

module Celluloid
  module Stomp

    class << self
      def included(klass)
        klass.send :include, ::Celluloid
        #klass.mailbox_class Celluloid::ZMQ::Mailbox
      end
    end

    BUFFER_SIZE = 100 * 1024

    class Reader
      include Celluloid::IO

      def read(io, parser, stomp)
        parser = StompParser::Parser.new
        loop do
          parser.parse(io.readpartial(BUFFER_SIZE)) do |frame|
            stomp.frame_received(parser, frame)
          end
        end
      end
    end

    def frame_received(parser, frame)
      puts "- signal -"
      p frame
      signal(:frame, frame)
    end

    def wait_for_frame(parser)
      puts "waiting!"
      wait(:frame)
    end

    class Parser
      def initialize(io)
        @io = io
        @reader = Reader.new_link
        @queue = Queue.new
        @parent = Actor.current
        @reader.read(io, self, @parent)
      end

      def next
        @parent.wait_for_frame(self)
      end
    end
  end
end
