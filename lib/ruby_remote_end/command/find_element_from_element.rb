module RubyRemoteEnd
	module Command
		class FindElementFromElement < Common
			verb :post
			uri_template '/session/{session id}/element/{element id}/element'
			RequestRouter.register(self)

			def execute
				e = element.element(location_strategy, selector)
				if e.exists?
					identifier = create_web_element_identifier
					session.known_elements[identifier] = e.ole_object
					success(identifier)
				else
					no_such_element
				end
			end

			def location_strategy
				payload.fetch('using')
			end

			def selector
				payload.fetch('value')
			end

			private

			def success(element_identifier)
				Response.new(
					'200',
					{
						'sessionId' => session.id,
						'status' => 0,
						'value' => {"ELEMENT" => element_identifier}
					}.to_json,
					'application/json'
				)
			end

			def no_such_element
				Response.new(
					'200',
					{
						'sessionId' => session.id,
						'status' => 7,
						'value' => {"message" => "no such element: Unable to locate element: {\"method\":\"#{location_strategy}\",\"selector\":\"#{selector}\"}"}
					}.to_json,
					'application/json'
				)
			end

			def create_web_element_identifier
				"element-#{SecureRandom.uuid}"
			end
		end
	end
end