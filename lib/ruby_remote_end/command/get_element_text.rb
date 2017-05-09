module RubyRemoteEnd
	module Command
		class GetElementText < Common
			verb :get
			uri_template '/session/{session id}/element/{element id}/text'
			RequestRouter.register(self)

			def execute
				success(element.text)
			end

			private

			def success(text)
				Response.new(
					'200',
					{
						'sessionId' => session.id,
						'status' => 0,
						'value' => text
					}.to_json,
					'application/json'
				)
			end
		end
	end
end
