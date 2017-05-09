module RubyRemoteEnd
	module Command
		class GetElementAttribute < Common
			verb :get
			uri_template '/session/{session id}/element/{element id}/attribute/{name}'
			RequestRouter.register(self)

			def execute
				success(element.attribute_value(attribute_name))
			end

			def attribute_name
				uri.split('/').last
			end

			private

			def success(attribute_value)
				Response.new(
					'200',
					{
						'sessionId' => session.id,
						'status' => 0,
						'value' => attribute_value
					}.to_json,
					'application/json'
				)
			end
		end
	end
end
