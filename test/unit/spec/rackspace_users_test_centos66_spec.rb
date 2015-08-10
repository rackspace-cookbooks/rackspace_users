require_relative 'spec_helper'
require_relative 'centos66_options'

describe 'rackspace_users_test::default on Centos 6.6' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(CENTOS66_SERVICE_OPTS) do |node|
      stub_all(node)
    end.converge('rackspace_users_test::default')
  end

  it_behaves_like 'users'
end
