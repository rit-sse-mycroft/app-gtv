require 'rubygems'
require 'bundler/setup'
require 'google_anymote'

module GTVRemote

  extend self
  @@cert = File.read(File.join(File.dirname(__FILE__),"certs/cert.pem"))
  @@host = "ssegoogletv.rit.edu"

  def open
    @@gtv = GoogleAnymote::TV.new(@@cert, @@host)
  end

  def close
    @@gtv = nil
  end

  def power_on
    @@gtv.send_keycode(Code.values[:KEYCODE_CALL])
  end

  def power_off
    @@gtv.send_keycode(Code.values[:KEYCODE_CALL])
    @@gtv.send_keycode(Code.values[:KEYCODE_POWER])
  end

  def open_uri(uri)
    @@gtv.fling_uri("about:blank")
    @@gtv.fling_uri(uri)
  end

  def fling(data)
    @@gtv.fling_uri(data)
  end
end
