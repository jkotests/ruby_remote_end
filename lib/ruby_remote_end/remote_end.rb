module RubyRemoteEnd
	class RemoteEnd
		attr_reader :adapter, :url_prefix
		attr_accessor :sessions

		def initialize(adapter, url_prefix)
			@adapter = adapter
			@url_prefix = url_prefix
			@sessions = []
		end

		def open_timeout=(value)
			# Required by Selenium 3
		end

		def read_timeout=(value)
			# Required by Selenium 3
		end

		def request(req)
			verb = req.method
			path = '/' + req.path.sub(url_prefix, '')

			command = RequestRouter.command(verb, path)
			response = execute(command, path, req.body)

			response
		end

		private

		def execute(command, uri, payload)
			opts = {session: nil, element: nil, uri: uri, payload: payload}

			session_id = session_id_from(uri)
			if session_id
				opts[:session] = session_for(session_id)
				# TODO: assert that the session exists
			end

			element_id = element_id_from(uri)
			if element_id
				opts[:element] = element_for(element_id, opts[:session])
				# TODO: assert that the element still exists
			end

			if command == Command::NewSession
				response, session = command.new(adapter).execute
				sessions << session
				response
			else
				command.new(opts).execute
			end
		end

		def session_id_from(uri)
			parts = uri.split('/')
			session_idx = parts.index('session')
			session_idx ? parts[session_idx + 1] : nil
		end

		def session_for(session_id)
			return nil if session_id.nil?
			sessions.find { |s| s.id == session_id }
		end

		def element_id_from(uri)
			parts = uri.split('/')
			element_idx = parts.index('element')
			element_idx ? parts[element_idx + 1] : nil
		end

		def element_for(element_id, session)
			e_ole = session.known_elements[element_id]
			session.current_browsing_context.element(:ole_object, e_ole)
		end
	end
end