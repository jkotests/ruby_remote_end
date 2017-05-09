require 'spec_helper'

RSpec.describe RubyRemoteEnd::Command::FindElement do
	it 'responds with success' do
		element = double('Element')
		allow(element).to receive(:exists?).and_return(true)
		allow(element).to receive(:ole_object).and_return(true)

		browser = double('Browser')
		allow(browser).to receive(:element).and_return(element)

		session = RubyRemoteEnd::Session.new(browser, id: 'session-123')
		payload = "{\"using\":\"id\",\"value\":\"lst-ib\"}"

		cmd = RubyRemoteEnd::Command::FindElement.new(session: session, payload: payload)
		allow(cmd).to receive(:create_web_element_identifier).and_return('element-4299a4fb')

		response = cmd.execute

		aggregate_failures do
			expect(response.code).to eq("200")
			body = JSON.parse(response.body)
			expect(body['sessionId']).to eq('session-123')
			expect(body['status']).to eq(0)
			expect(body['value']['ELEMENT']).to eq('element-4299a4fb')
			expect(response.content_type).to eq("application/json")
		end
	end

	it 'responds with no such element' do
		element = double('Element')
		allow(element).to receive(:exists?).and_return(false)
		browser = double('Browser')
		allow(browser).to receive(:element).and_return(element)

		session = RubyRemoteEnd::Session.new(browser, id: 'session-123')
		payload = "{\"using\":\"id\",\"value\":\"missing_id\"}"

		cmd = RubyRemoteEnd::Command::FindElement.new(session: session, payload: payload)
		allow(cmd).to receive(:create_web_element_identifier).and_return('element-4299a4fb-e410-4d0f-aab5-4af8fb1f27e8')

		response = cmd.execute

		aggregate_failures do
			expect(response.code).to eq('200')
			body = JSON.parse(response.body)
			expect(body['sessionId']).to eq('session-123')
			expect(body['status']).to eq(7)
			expect(body['value']['message']).to eq('no such element: Unable to locate element: {"method":"id","selector":"missing_id"}')
			expect(response.content_type).to eq('application/json')
		end
	end
end