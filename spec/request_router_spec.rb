require 'spec_helper'

module RubyRemoteEnd
	RSpec.describe RequestRouter do
		it 'identifies the new session command' do
			expect(RequestRouter.command('POST', '/session')).to eq(Command::NewSession)
		end

		it 'identifies session commands' do
			expect(RequestRouter.command('POST', '/session/session-123/url')).to eq(Command::Go)
		end

		it 'identifies element commands' do
			expect(RequestRouter.command('GET', '/session/session-123/element/element-abc/attribute/something')).to eq(Command::GetElementAttribute)
		end
	end
end