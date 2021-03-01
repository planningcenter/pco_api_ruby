require_relative '../spec_helper'

describe PCO::API do
  describe '.new' do
    it 'creates a new Endpoint instance' do
      expect(described_class.new(basic_auth_token: 'abc123', basic_auth_secret: 'xyz789').class).to eq(PCO::API::Endpoint)
    end
  end
end
