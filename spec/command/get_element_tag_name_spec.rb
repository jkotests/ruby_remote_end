require 'spec_helper'

RSpec.describe RubyRemoteEnd::Command::GetElementTagName do
	it 'responds with success' do
		session = double('Session')
		allow(session).to receive(:id).and_return('session-123')
		element = double('Element')
		allow(element).to receive(:tag_name).and_return('a_tag_name')

		cmd = RubyRemoteEnd::Command::GetElementTagName.new(session: session, element: element)

		response = cmd.execute

		aggregate_failures do
			expect(response.code).to eq('200')
			body = JSON.parse(response.body)
			expect(body['sessionId']).to eq('session-123')
			expect(body['status']).to eq(0)
			expect(body['value']).to eq('a_tag_name')
			expect(response.content_type).to eq('application/json')
		end
	end
end