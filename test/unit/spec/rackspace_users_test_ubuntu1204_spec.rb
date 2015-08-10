require_relative 'spec_helper'
require_relative 'ubuntu1204_options'

describe 'rackspace_users_test::default on Ubuntu 12.04' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(UBUNTU1204_SERVICE_OPTS) do |node|
      stub_all(node)
    end.converge('rackspace_users_test::default')
  end

  it_behaves_like 'users'
end
