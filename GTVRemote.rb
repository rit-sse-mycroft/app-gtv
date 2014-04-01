require 'rubygems'
require 'bundler/setup'
require 'google_anymote'

module GTVRemote

  @gtv_cert = File.read(File.join(File.dirname(__FILE__),"certs/cert.pem"))
  @host = "ssegoogletv.rit.edu"

  def pair
    @gtv = GoogleAnymote::TV.new(@gtv_cert, @host)
  end

  def unpair
    @gtv = nil
  end

  def fling(uri)
    @gtv.fling_uri(uri)
  end

  def send_keycode(k)
    @gtv.send_keycode(Code.values[k.to_sym]) unless Code.values[k.to_sym].nil?
  end
end
