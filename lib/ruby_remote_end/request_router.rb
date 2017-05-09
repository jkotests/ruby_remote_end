module RubyRemoteEnd
	class RequestRouter
		@commands = []

		def self.command(verb, uri)
			cmd = @commands.find { |cmd| cmd.matches?(verb, uri) }
			raise("Command not defined - verb: '#{verb}', uri: '#{uri}'") unless cmd
			cmd
		end

		def self.register(cmd_klass)
			@commands << cmd_klass
		end
	end
end