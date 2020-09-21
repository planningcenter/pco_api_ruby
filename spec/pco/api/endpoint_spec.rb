require_relative '../../spec_helper'
require 'json'

describe PCO::API::Endpoint do
  let(:base) { described_class.new(basic_auth_token: 'token', basic_auth_secret: 'secret') }

  subject { base }

  describe '#method_missing' do
    before do
      @result = subject.people.v2
    end

    it 'returns a wrapper object with updated url' do
      expect(@result).to be_a(described_class)
      expect(@result.url).to match(%r{/people/v2$})
    end
  end

  describe '#[]' do
    before do
      @result = subject.people.v2.people[1]
    end

    it 'returns a wrapper object with updated url' do
      expect(@result).to be_a(described_class)
      expect(@result.url).to match(%r{/people/v2/people/1$})
    end
  end

  describe '#get' do
    context 'given a good URL' do
      subject { base.people.v2 }

      let(:result) do
        {
          'type'  => 'Organization',
          'id'    => '1',
          'name'  => 'Ministry Centered Technologies',
          'links' => {}
        }
      end

      before do
        stub_request(:get, 'https://api.planningcenteronline.com/people/v2')
          .to_return(status: 200, body: { data: result }.to_json, headers: { 'Content-Type' => 'application/vnd.api+json' })
        @result = subject.get
      end

      it 'returns the result of making a GET request to the endpoint' do
        expect(@result).to be_a(Hash)
        expect(@result['data']).to eq(result)
        expect(@result.headers).to eq('Content-Type' => 'application/vnd.api+json')
      end
    end

    context 'given a non-existent URL' do
      subject { base.people.v2.non_existent }

      let(:result) do
        {
          'status'  => 404,
          'message' => 'Resource Not Found'
        }
      end

      before do
        stub_request(:get, 'https://api.planningcenteronline.com/people/v2/non_existent')
          .to_return(status: 404, body: result.to_json, headers: { 'Content-Type' => 'application/vnd.api+json' })
      end

      it 'raises a NotFound error' do
        error = begin
                  subject.get
                rescue PCO::API::Errors::NotFound => e
                  e
                end
        expect(error.status).to eq(404)
        expect(error.message).to eq('Resource Not Found')
        expect(error.headers).to eq('Content-Type' => 'application/vnd.api+json')
      end
    end

    context 'given a client error' do
      subject { base.people.v2.error }

      let(:result) do
        {
          'status'  => 400,
          'message' => 'Bad request'
        }
      end

      before do
        stub_request(:get, 'https://api.planningcenteronline.com/people/v2/error')
          .to_return(status: 400, body: result.to_json, headers: { 'Content-Type' => 'application/vnd.api+json' })
      end

      it 'raises a ClientError error' do
        expect {
          subject.get
        }.to raise_error(PCO::API::Errors::ClientError)
      end
    end

    context 'given a server error' do
      subject { base.people.v2.error }

      let(:result) do
        {
          'status'  => 500,
          'message' => 'System error has occurred'
        }
      end

      before do
        stub_request(:get, 'https://api.planningcenteronline.com/people/v2/error')
          .to_return(status: 500, body: result.to_json, headers: { 'Content-Type' => 'application/vnd.api+json' })
      end

      it 'raises a ServerError error' do
        expect {
          subject.get
        }.to raise_error(PCO::API::Errors::ServerError)
      end
    end
  end

  describe '#post' do
    subject { base.people.v2.people }

    let(:resource) do
      {
        'type'       => 'Person',
        'first_name' => 'Tim',
        'last_name'  => 'Morgan'
      }
    end

    let(:result) do
      {
        'type'       => 'Person',
        'id'         => '1',
        'first_name' => 'Tim',
        'last_name'  => 'Morgan'
      }
    end

    before do
      stub_request(:post, 'https://api.planningcenteronline.com/people/v2/people')
        .to_return(status: 201, body: { data: result }.to_json, headers: { 'Content-Type' => 'application/vnd.api+json' })
      @result = subject.post(data: resource)
    end

    it 'returns the result of making a POST request to the endpoint' do
      expect(@result).to be_a(Hash)
      expect(@result['data']).to eq(result)
    end
  end

  describe '#patch' do
    subject { base.people.v2.people[1] }

    let(:resource) do
      {
        'type'       => 'Person',
        'first_name' => 'Tim',
        'last_name'  => 'Morgan'
      }
    end

    let(:result) do
      {
        'type'       => 'Person',
        'id'         => '1',
        'first_name' => 'Tim',
        'last_name'  => 'Morgan'
      }
    end

    before do
      stub_request(:patch, 'https://api.planningcenteronline.com/people/v2/people/1')
        .to_return(status: 200, body: { data: result }.to_json, headers: { 'Content-Type' => 'application/vnd.api+json' })
      @result = subject.patch(data: resource)
    end

    it 'returns the result of making a PATCH request to the endpoint' do
      expect(@result).to be_a(Hash)
      expect(@result['data']).to eq(result)
    end
  end

  describe '#delete' do
    subject { base.people.v2.people[1] }

    before do
      stub_request(:delete, 'https://api.planningcenteronline.com/people/v2/people/1')
        .to_return(status: 204, body: '')
      @result = subject.delete
    end

    it 'returns true' do
      expect(@result).to eq(true)
    end
  end
end
