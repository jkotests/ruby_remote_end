module RubyRemoteEnd
	module Command
		class GetElementTagName < Common
			verb :get
			uri_template '/session/{session id}/element/{element id}/name'
			RequestRouter.register(self)

			def execute
				success(element.tag_name)
			end

			private

			def success(value)
				Response.new(
					'200',
					{
						'sessionId' => session.id,
						'status' => 0,
						'value' => value
					}.to_json,
					'application/json'
				)
			end
		end
	end
end
