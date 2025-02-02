require "./spec_helper"
require "../src/tasks/utils/utils.cr"
require "colorize"

describe CnfConformance do
  before_all do
    # LOGGING.debug `pwd` 
    # LOGGING.debug `echo $KUBECONFIG`
    `./cnf-conformance samples_cleanup`
    $?.success?.should be_true
    `./cnf-conformance setup`
    $?.success?.should be_true
    # `./cnf-conformance sample_coredns_with_wait_setup`
    # $?.success?.should be_true
  end

  after_all do
    # LOGGING.debug `pwd` 
    # LOGGING.debug `echo $KUBECONFIG`
    `./cnf-conformance samples_cleanup`
    $?.success?.should be_true
  end

  it "'all' should run the whole test suite", tags: "happy-path" do
    # LOGGING.debug `pwd` 
    # LOGGING.debug `echo $KUBECONFIG`
    # Test the binary
    # Build should already be present
    # build_s = `crystal build src/cnf-conformance.cr`
    # $?.success?.should be_true
    # LOGGING.debug build_s 
    `./cnf-conformance samples_cleanup`
    response_s = `./cnf-conformance all cnf-config=./sample-cnfs/sample-coredns-cnf/cnf-conformance.yml verbose`
    LOGGING.info response_s
    (/PASSED: Helm readiness probe found/ =~ response_s).should_not be_nil
    (/PASSED: Helm liveness probe/ =~ response_s).should_not be_nil
    (/Lint Passed/ =~ response_s).should_not be_nil
    (/PASSED: Replicas increased to 3/ =~ response_s).should_not be_nil
    (/PASSED: Replicas decreased to 1/ =~ response_s).should_not be_nil
    (/PASSED: Published Helm Chart Found/ =~ response_s).should_not be_nil
    (/Final workload score:/ =~ response_s).should_not be_nil
    (/Final platform score:/ =~ response_s).should_not be_nil
    (/Final score:/ =~ response_s).should_not be_nil
    (all_result_test_names(CNFManager.final_cnf_results_yml)).should eq(["volume_hostpath_not_found", "privileged", "increase_capacity", "decrease_capacity", "ip_addresses", "liveness", "readiness", "rolling_update", "nodeport_not_used", "hardcoded_ip_addresses_in_k8s_runtime_configuration", "install_script_helm", "helm_chart_valid", "helm_chart_published","helm_deploy", "reasonable_image_size", "reasonable_startup_time", "chaos_network_loss", "chaos_cpu_hog", "chaos_container_kill", "k8s_conformance", "oci_compliant"])
    $?.success?.should be_true
  end

  it "'scalability' should run all of the scalability tests", tags: "happy-path"  do
    # LOGGING.debug `pwd` 
    # LOGGING.debug `echo $KUBECONFIG`
    `./cnf-conformance samples_cleanup`
    response_s = `./cnf-conformance setup`
    LOGGING.info response_s
    `./cnf-conformance sample_coredns_with_wait_setup`
    $?.success?.should be_true
    response_s = `./cnf-conformance scalability`
    LOGGING.info response_s
    $?.success?.should be_true
    (/PASSED: Replicas increased to 3/ =~ response_s).should_not be_nil
    (/PASSED: Replicas decreased to 1/ =~ response_s).should_not be_nil
  end

end
