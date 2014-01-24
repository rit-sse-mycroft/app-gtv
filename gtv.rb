# require 'rubygems'
require 'mycroft'
require 'json'
require_relative "GTVRemote"

class Gtv < Mycroft::Client

  attr_accessor :verified

  def initialize(host, port)
    @key = '/path/to/key'
    @cert = '/path/to/cert'
    @manifest = './app.json'
    @verified = false
    @gtv_packages = JSON.parse(File.read("package_names.json"))
    super
  end

  def connect
    GTVRemote::open()
  end

  def on_data(data)
    if data[:type] == 'MSG_BROADCAST'
      # Ensure this broadcast is for us
      unless (data[:data]["content"].has_key?("grammar") and data[:data]["content"]["grammar"] == "Google TV")
        puts "Grammar isn't being matched oops"
        return
      end
      # Get the app from the broadcast
      app = data[:data]["content"]["tags"]["app"].downcase
      
      # Make sure we recognize the command.
      unless @gtv_packages.has_key?(app)
        return
      end
      
      # Send the appropriate intent to the GTV
      GTVRemote::fling(@gtv_packages[app])

    elsif data[:type] == 'MSG_QUERY'
      # Do stuff
    elsif data[:type] == 'APP_MANIFEST_OK'
      # Do stuff
      grammar = File.read("./grammar.xml")
      data = {
        "grammar"=> {
          "name"=> "Google TV",
          "xml"=> grammar
        }
      }
      query("stt", "load_grammar", data)

    elsif data[:type] == 'APP_DEPENDENCY'
      # Do stuff
    end
  end

  def on_end
    GTVRemote::close()
  end
end

Mycroft.start(Gtv)
