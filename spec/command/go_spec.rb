require 'spec_helper'

RSpec.describe RubyRemoteEnd::Command::Go do
	it 'responds with success' do
		browser = double('Browser')
		allow(browser).to receive(:goto)

		session = RubyRemoteEnd::Session.new(browser, id: 'session-123')
		payload = "{\"url\":\"http://www.google.ca\"}"

		cmd = RubyRemoteEnd::Command::Go.new(session: session, payload: payload)

		response = cmd.execute

		aggregate_failures do
			expect(response.code).to eq('200')
			body = JSON.parse(response.body)
			expect(body['sessionId']).to eq('session-123')
			expect(body['status']).to eq(0)
			expect(body['value']).to eq(nil)
			expect(response.content_type).to eq('application/json')
		end
	end
end