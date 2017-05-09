module RubyRemoteEnd
	module Command
		class NewSession < Common
			verb :post
			uri_template '/session'
			RequestRouter.register(self)

			attr_reader :adapter

			def initialize(adapter)
				@adapter = adapter
			end

			def execute
				session = RubyRemoteEnd.const_get(adapter).const_get(:Session).start
				return success(session), session
			end

			private

			def success(session)
				Response.new(
					'200',
					{
						'sessionId' => session.id,
						'status' => 0,
						'value' => {} # TODO: determine what values are required
					}.to_json,
					'application/json'
				)
			end
		end
	end
end