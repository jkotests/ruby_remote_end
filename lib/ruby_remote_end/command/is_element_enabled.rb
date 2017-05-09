module RubyRemoteEnd
	module Command
		class IsElementEnabled < Common
			verb :get
			uri_template '/session/{session id}/element/{element id}/enabled'
			RequestRouter.register(self)

			def execute
				success(element.enabled?)
			end

			private

			def success(enabled)
				Response.new(
					'200',
					{
						'sessionId' => session.id,
						'status' => 0,
						'value' => enabled
					}.to_json,
					'application/json'
				)
			end
		end
	end
end
