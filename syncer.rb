require "aws-sdk-ssm"
require "base64"

class Syncer
  def initialize(observed)
    @parent = observed["parent"]
    @children = observed["children"]
    @client = Aws::SSM::Client.new
  end

  def fetch_params
    resp = @client.get_parameters_by_path({
      path: @parent["spec"]["path"],
      recursive: true,
      with_decryption: true,
    })

    params = []
    loop do
      params += resp.parameters
      break if resp.next_token.nil?
      resp = @client.get_parameters_by_path({
        path: @parent["spec"]["path"],
        recursive: true,
        with_decryption: true,
        next_token: resp.next_token,
      })
    end

    params
  end

  def desired
    {
      status: desired_status,
      children: desired_secrets,
    }
  end

  def desired_status
    {secrets: @children.length}
  end

  def desired_secrets
    params = fetch_params
    [
      {
        apiVersion: "v1",
        kind: "Secret",
        metadata: {name: @parent["metadata"]["name"]},
        data: params.map { |param|
          [
            param.name.delete_prefix(@parent["spec"]["path"]),
            Base64.strict_encode64(param.value),
          ]
        }.to_h,
      },
    ]
  end
end
