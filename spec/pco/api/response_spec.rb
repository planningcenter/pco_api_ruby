require_relative '../../spec_helper'
require 'pry'

describe PCO::API::Response do
  let(:response_hash) { json_fixture('responses/index_people.json') }
  let(:response) { described_class[response_hash] }

  subject { response }

  describe "data" do
    subject { response.data }

    it { is_expected.to(be_a(Array)) }
    it "parses array as an array of resources" do
      expect(subject.first).to be_a(PCO::API::Resource)
    end

    it "allows dot notation to access resource" do
      expect(subject.first.type).to eq("Person")
      expect(subject.first.id).to eq("1")
      expect(subject.first.attributes.first_name).to eq("Han")
      expect(subject.first.attributes.last_name).to eq("Solo")
    end

    it "allows dot notation to access a resource's included relationships" do
      expect(subject.first.emails).to be_a(Array)
      expect(subject.first.emails.count).to eq(2)
      expect(subject.first.emails.first.id).to eq("1")
      expect(subject.first.emails.first.attributes.address).to eq("han.solo@pco.test")
      expect(subject.first.emails.first.attributes.primary).to eq(true)
    end

    it "works with has_one relationship" do
      expect(subject.first.gender).to be_a(PCO::API::Resource)
      expect(subject.first.gender.id).to eq("1")
      expect(subject.first.gender.attributes.value).to eq("Male")
    end

    describe "individual resource pages" do
      let(:response_hash) { json_fixture('responses/show_person.json') }

      it { is_expected.to(be_a(PCO::API::Resource)) }

      it "allows dot notation to access resource" do
        expect(subject.type).to eq("Person")
        expect(subject.id).to eq("1")
        expect(subject.attributes.first_name).to eq("Han")
        expect(subject.attributes.last_name).to eq("Solo")
      end
    end
  end
end
