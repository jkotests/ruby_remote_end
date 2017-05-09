module RubyRemoteEnd
	module Command
		class ElementClick < Common
			verb :post
			uri_template '/session/{session id}/element/{element id}/click'
			RequestRouter.register(self)

			def execute
				element.click
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
