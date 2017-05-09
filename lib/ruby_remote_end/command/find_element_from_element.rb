module RubyRemoteEnd
	module Command
		class FindElementFromElement < Common
			verb :post
			uri_template '/session/{session id}/element/{element id}/element'
			RequestRouter.register(self)

			def execute
				start_ole = session.known_elements[element_id]
				start_node = session.current_browsing_context.element(:ole_object, start_ole)

				e = start_node.element(location_strategy, selector)
				if e.exists?
					identifier = create_web_element_identifier
					session.known_elements[identifier] = e.ole_object
					success(identifier)
				else
					no_such_element
				end
			end

			def location_strategy
				JSON.parse(payload).fetch('using')
			end

			def selector
				JSON.parse(payload).fetch('value')
			end

			def element_id
				uri_parameters['element_id']
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