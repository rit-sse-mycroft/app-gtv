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

  on 'connect' do
    GTVRemote::open
  end

  on 'MSG_BROADCAST' do |data|
    unless (data["content"].has_key?("grammar") and data["content"]["grammar"] == "Google TV")
      puts "Grammar isn't being matched oops"
      return
    end
    # Get the app from the broadcast
    app = data["content"]["tags"]["app"].downcase
    
    open_app(app)
  end

  on 'MSG_QUERY' do |data|
    puts data["action"]
    if data["action"].downcase == "app"
      #TODO: Validate Query
      app = data["data"]["app"].downcase
      puts app
      open_app(app)
    elsif data["action"].downcase == "url"
      #TODO: Validate Query
      url = data["data"]["url"]
      if (not url.downcase.include?("http")) # Make sure URL has http:// in front
        url = "http://" + url
      end
      GTVRemote::open_uri(url)
    end
  end

  on 'APP_MANIFEST_OK' do |data|
    grammar = File.read("./grammar.xml")
    data = {
      "grammar"=> {
        "name"=> "Google TV",
        "xml"=> grammar
      }
    }
    query("stt", "load_grammar", data)
  end

  on 'end' do 
    GTVRemote::close
    query('stt', 'unload_grammar', {grammar: 'Google TV'})
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
