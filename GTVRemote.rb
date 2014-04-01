require 'rubygems'
require 'bundler/setup'
require 'google_anymote'

module GTVRemote

  def pair
    @gtv_cert = File.read(@config['cert'] || 'certs/cert.pem')
    @host = "ssegoogletv.rit.edu"
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
