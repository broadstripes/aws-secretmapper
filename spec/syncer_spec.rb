require_relative "../syncer"

RSpec.describe Syncer do
  let(:empty_resp) { double(:resp, next_token: nil, parameters: []) }

  it "exists" do
    expect { Syncer.new({}) }.not_to raise_error
  end

  describe ".fetch_params" do
    it "passes the path to the client" do
      client = double(:client)
      allow(Aws::SSM::Client).to receive(:new).and_return(client)
      syncer = Syncer.new({"parent" => {"spec" => {"path" => "some path"}}})

      expect(client).to receive(:get_parameters_by_path).
        with(hash_including(path: "some path")).
        and_return(empty_resp)

      syncer.fetch_params
    end

    it "handles no params" do
      client = double(:client)
      allow(client).to receive(:get_parameters_by_path).
        and_return(empty_resp)
      allow(Aws::SSM::Client).to receive(:new).and_return(client)
      syncer = Syncer.new({"parent" => {"spec" => {}}})

      expect(syncer.fetch_params).to eq []
    end
  end
end
