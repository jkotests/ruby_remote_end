module RubyRemoteEnd
	module Command
		class Go < Common
			verb :post
			uri_template '/session/{session id}/url'
			RequestRouter.register(self)

			def execute
				session.goto(url)
				success
			end

			def url
				payload.fetch('url')
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
