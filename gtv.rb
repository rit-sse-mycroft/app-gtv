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
      
      open_app(app)

    elsif data[:type] == 'MSG_QUERY'
      puts data[:data]["action"]
      if data[:data]["action"].downcase == "app"
        #TODO: Validate Query
        app = data[:data]["data"]["app"].downcase
        puts app
        open_app(app)
      elsif data[:data]["action"].downcase == "url"
        #TODO: Validate Query
        url = data[:data]["data"]["url"]
        if (not url.downcase.include?("http")) # Make sure URL has http:// in front
          url = "http://" + url
        end
        GTVRemote::open_uri(url)
      end
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

  def open_app(app)
      # Make sure we recognize the command.
      unless @gtv_packages.has_key?(app)
        return
      end
      
      # Send the appropriate intent to the GTV
      GTVRemote::fling(@gtv_packages[app])
  end
end

Mycroft.start(Gtv)
