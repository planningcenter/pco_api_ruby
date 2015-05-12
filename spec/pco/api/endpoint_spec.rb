require_relative '../../spec_helper'
require 'json'

describe PCO::API::Endpoint do
  let(:base) { described_class.new(auth_token: 'token', auth_secret: 'secret') }

  subject { base }

  describe '#people#v1' do
    before do
      @result = subject.people.v1
    end

    it 'returns a wrapper object with updated url' do
      expect(@result).to be_a(described_class)
      expect(@result.url).to match(%r{/people/v1$})
    end
  end

  describe '#get' do
    context 'given a good URL' do
      subject { base.people.v1 }

      let(:result) do
        {
          'type'  => 'Organization',
          'id'    => '1',
          'name'  => 'Ministry Centered Technologies',
          'links' => {}
        }
      end

      before do
        stub_request(:get, 'https://api.planningcenteronline.com/people/v1')
          .to_return(status: 200, body: { data: result }.to_json, headers: { 'Content-Type' => 'application/vnd.api+json' })
        @result = subject.get
      end

      it 'returns the result of making a GET request to the endpoint' do
        expect(@result).to be_a(Hash)
        expect(@result['data']).to eq(result)
      end
    end

    context 'given a non-existent URL' do
      subject { base.people.v1.non_existent }

      let(:result) do
        {
          'status'  => 404,
          'message' => 'Resource Not Found'
        }
      end

      before do
        stub_request(:get, 'https://api.planningcenteronline.com/people/v1/non_existent')
          .to_return(status: 404, body: result.to_json, headers: { 'Content-Type' => 'application/vnd.api+json' })
      end

      it 'raises an NotFound error' do
        expect {
          subject.get
        }.to raise_error(PCO::API::Errors::NotFound)
      end
    end
  end
end
