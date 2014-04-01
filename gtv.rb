# require 'rubygems'
require 'mycroft'
require 'json'
require_relative "GTVRemote"

class Gtv < Mycroft::Client
  include GTVRemote

  def initialize(host, port)
    @key = ''
    @cert = ''
    @manifest = './app.json'
    @verified = false
    @sent_grammar = false
    @gtv_packages = JSON.parse(File.read("package_names.json"))
    GTVRemote::open
    super
  end

  on 'APP_DEPENDENCY' do |data|
    up
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

  on 'CONNECTION_CLOSED' do
    GTVRemote::close
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
