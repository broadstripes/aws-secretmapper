require_relative "../syncer"

RSpec.describe Syncer do
  let(:dummy_param) { double(:param)}
  let(:empty_resp) { double(:resp, next_token: nil, parameters: []) }
  let(:dummy_resp) {
    double(
      :resp,
      next_token: nil,
      parameters: [double(:param, name: 'dummy', value: 'secret dummy value')]
    )
  }
  let(:client) { double(:client) }

  it "exists" do
    expect { Syncer.new({}) }.not_to raise_error
  end

  describe ".fetch_params" do
    it "passes the path to the client" do
      allow(Aws::SSM::Client).to receive(:new).and_return(client)
      syncer = Syncer.new({"parent" => {"spec" => {"path" => "some path"}}})

      expect(client).to receive(:get_parameters_by_path).
        with(hash_including(path: "some path")).
        and_return(empty_resp)

      syncer.fetch_params
    end

    it "handles no params" do
      allow(client).to receive(:get_parameters_by_path).
        and_return(empty_resp)
      allow(Aws::SSM::Client).to receive(:new).and_return(client)
      syncer = Syncer.new({"parent" => {"spec" => {}}})

      expect(syncer.fetch_params).to eq []
    end
  end

  describe ".desired_secrets" do
    it "defaults type to Opaque" do
      allow(Aws::SSM::Client).to receive(:new).and_return(client)
      allow(client).to receive(:get_parameters_by_path).
        and_return(dummy_resp)
      observed = {
        "parent" => {
          "metadata" => {"name" => "dummy-mapping"},
          "spec" => {}
        }
      }
      secrets = Syncer.new(observed).desired_secrets
      secret = secrets[0]
      expect(secret).to have_key :type
      expect(secret[:type]).to eq "Opaque"
    end

    it "adds the type field if given" do
      allow(Aws::SSM::Client).to receive(:new).and_return(client)
      allow(client).to receive(:get_parameters_by_path).
        and_return(dummy_resp)
      observed = {
        "parent" => {
          "metadata" => {"name" => "dummy-mapping"},
          "spec" => {
            "type" => "foobar"
          }
        }
      }
      secrets = Syncer.new(observed).desired_secrets
      secret = secrets[0]
      expect(secret).to have_key :type
      expect(secret[:type]).to eq "foobar"
    end
  end
end
