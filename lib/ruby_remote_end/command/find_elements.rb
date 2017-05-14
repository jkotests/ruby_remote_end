module RubyRemoteEnd
	module Command
		class FindElements < Common
			verb :post
			uri_template '/session/{session id}/elements'
			RequestRouter.register(self)

			def execute
				es = session.elements(location_strategy, selector)
				identifiers = []
				es.each do |e|
					identifier = create_web_element_identifier
					identifiers << identifier
					session.known_elements[identifier] = e.ole_object
				end
				success(identifiers)
			end

			def location_strategy
				payload.fetch('using')
			end

			def selector
				payload.fetch('value')
			end

			private

			def success(element_identifiers)
				value = element_identifiers.map { |i| {"ELEMENT" => i} }

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

			def create_web_element_identifier
				"element-#{SecureRandom.uuid}"
			end
		end
	end
end