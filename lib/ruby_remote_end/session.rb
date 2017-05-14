module RubyRemoteEnd
	class Session
		attr_reader :browser, :id, :known_elements

		def self.start
			new(initialize_browser)
		end

		def initialize(browser, id: generate_session_id)
			@browser = browser
			@id = id
			@known_elements = {}
		end

		def top_level_browser_context
			browser
		end

		def current_browsing_context
			browser
		end

		def goto(url)
			top_level_browser_context.goto(url)
		end

		def element(location_strategy, selector)
			current_browsing_context.element(location_strategy, selector)
		end

		def elements(location_strategy, selector)
			current_browsing_context.elements(location_strategy, selector)
		end

		private

		def generate_session_id
			SecureRandom.uuid
		end
	end
end