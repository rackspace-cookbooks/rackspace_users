require_relative 'spec_helper'
require_relative 'centos67_options'

describe 'rackspace_users_test::override on Centos 6.7' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(CENTOS67_SERVICE_OPTS) do |node|
      stub_all(node)
    end.converge('rackspace_users_test::override')
  end

  it_behaves_like 'users override'
end
