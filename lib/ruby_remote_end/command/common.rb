module RubyRemoteEnd
	module Command
		class Common
			attr_reader :session, :element, :uri, :payload

			def self.verb(value)
				@verb = value
			end

			def self.uri_template(value)
				@uri_template = value
			end

			def self.matches?(verb, uri)
				matches_verb?(verb) && matches_uri?(uri)
			end

			def self.matches_verb?(value)
				value.downcase.to_sym == @verb
			end

			def self.matches_uri?(value)
				uri = value.split('/')
				template = @uri_template.split('/')
				return false unless uri.count == template.count
				uri.zip(template) do |actual, expected|
					next if expected.start_with?('{')
					return false unless actual == expected
				end
				true
			end

			def initialize(session: nil, element: nil, uri: nil, payload: nil)
				@session = session
				@element = element
				@uri = uri
				@payload = payload && JSON.parse(payload)
			end
		end
	end
end