require 'mycroft'
require_relative "GTVRemote"

class Gtv < Mycroft::Client

  attr_accessor :verified

  def initialize(host, port)
    @key = '/path/to/key'
    @cert = '/path/to/cert'
    @manifest = './app.json'
    @verified = false
    super
  end

  def connect
    GTVRemote::open()
  end

  def on_data(data)
    if data[:type] == 'MSG_BROADCAST'
      puts data[:data]
      GTVRemote::interpret_broadcast(data[:data]["content"])
    end
  end

  def on_end
    GTVRemote::close()
  end
end

Mycroft.start(Gtv)
