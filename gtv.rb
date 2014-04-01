# require 'rubygems'
require 'mycroft'
require 'json'
require_relative "GTVRemote"

class GTV < Mycroft::Client
  include GTVRemote

  def initialize(host, port)
    @key = ''
    @cert = ''
    @manifest = './app.json'
    @verified = false
    @sent_grammar = false
    pair
    super
  end

  on 'APP_DEPENDENCY' do |data|
    up
  end

  on 'MSG_QUERY' do |data|
    if data['action'] == 'send_keycode'
      send_keycode(data['data']['keycode'])
    elsif data['action'] == 'fling'
      fling(data['data']['uri'])
    end
  end

  on 'CONNECTION_CLOSED' do
    unpair
  end

  on 'ERROR' do |err|
    puts err
  end
end

Mycroft.start(GTV)
