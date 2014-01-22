require 'rubygems'
require 'json'
require 'bundler/setup'
require 'google_anymote'

module GTVRemote
	@@cert = File.read(File.join(File.dirname(__FILE__),"certs/cert.pem"))
	@@host = "ssegoogletv.rit.edu"
	@@gtv = nil
	@@apps = JSON.parse(File.read("package_names.json"))
	
	def self.interpret_broadcast(data)
		@@apps.each do |key, value|
			if data.include?(key)
				self.open_app(key)
			end
		end
	end

	def self.open()
		@@gtv = GoogleAnymote::TV.new(@@cert, @@host)
	end

	def self.close()
		@@gtv = nil
	end

	def self.power_on()
		@@gtv.send_keycode(Code.values[:KEYCODE_CALL])
	end

	def self.power_off()
		@@gtv.send_keycode(Code.values[:KEYCODE_CALL])
		@@gtv.send_keycode(Code.values[:KEYCODE_POWER])
	end

	def self.open_uri(uri)
		@@gtv.fling_uri("about:blank")
		@@gtv.fling_uri(uri)
	end

	def self.open_app(app)
		@@gtv.fling_uri(@@apps[app])
	end
end
