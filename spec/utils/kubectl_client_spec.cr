require "../spec_helper"
require "colorize"
require "../../src/tasks/utils/utils.cr"
require "../../src/tasks/utils/kubectl_client.cr"
require "file_utils"
require "sam"

describe "KubectlClient" do
  # after_all do
  # end
  it "'#KubectlClient.get_nodes' should return the information about a node in json"  do
    json = KubectlClient::Get.nodes
    (json["items"].size).should be > 0
  end
  it "'#KubectlClient.container_runtime' should return the information about a node in json"  do
    resp = KubectlClient::Get.container_runtime
    (resp.match(KubectlClient::OCI_RUNTIME_REGEX)).should_not be_nil
  end
  it "'#KubectlClient.container_runtimes' should return all container runtimes"  do
    resp = KubectlClient::Get.container_runtimes
    (resp[0].match(KubectlClient::OCI_RUNTIME_REGEX)).should_not be_nil
  end
 
end

