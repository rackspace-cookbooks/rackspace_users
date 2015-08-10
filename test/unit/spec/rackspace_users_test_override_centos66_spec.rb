require_relative 'spec_helper'
require_relative 'centos66_options'

describe 'rackspace_users_test::override on Centos 6.6' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(CENTOS66_SERVICE_OPTS) do |node|
      stub_all(node)
    end.converge('rackspace_users_test::override')
  end

  it_behaves_like 'users override'
end
