module RubyRemoteEnd
	class Response
		attr_reader :code, :body, :content_type

		def initialize(code, body, content_type)
			@code = code
			@body = body
			@content_type = content_type
		end
	end
end