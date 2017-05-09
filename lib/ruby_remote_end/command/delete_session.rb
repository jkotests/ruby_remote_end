module RubyRemoteEnd
	module Command
		class DeleteSession < Common
			verb :delete
			uri_template '/session/{session id}'
			RequestRouter.register(self)

			def execute
				session.top_level_browser_context.close
				success
			end

			private

			def success
				Response.new(
					'200',
					{
						'sessionId' => session.id,
						'status' => 0,
						'value' => nil
					}.to_json,
					'application/json'
				)
			end
		end
	end
end
