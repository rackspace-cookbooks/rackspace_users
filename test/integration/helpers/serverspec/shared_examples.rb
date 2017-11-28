shared_examples_for 'users' do
  # olduser
  describe user('olduser') do
    it { should_not exist }
  end
  describe file('/etc/sudoers.d/olduser') do
    it { should_not exist }
  end

  # testuser
  describe user('testuser') do
    it { should exist }
    it { should belong_to_group 'testuser' }
  end

  describe file('/etc/sudoers.d/testuser') do
    it { should_not exist }
  end

  # newuser1
  describe user('newuser1') do
    it { should exist }
    it { should belong_to_group 'newuser1' }
  end

  describe file('/etc/sudoers.d/newuser1') do
    its(:content) { should match(/newuser1 ALL=\(ALL\) ALL/) }
  end

  # newuser2
  describe group('newgroup') do
    it { should exist }
    it { should have_gid 2000 }
  end

  describe user('newuser2') do
    it { should exist }
    it { should belong_to_group 'newgroup' }
    it { should belong_to_group 'newgroup2' }
    it { should have_uid 2000 }
    it { should have_home_directory '/home/custom_home_directory' }
    it { should have_login_shell '/bin/dash' }
    it { should have_authorized_key 'key1' }
    it { should have_authorized_key 'key2' }
    its(:minimum_days_between_password_change) { should eq 30 }
    its(:maximum_days_between_password_change) { should eq 60 }
  end

  describe command('grep newuser2 /etc/shadow | cut -f2 -d:') do
    its(:stdout) { should match(%r{\$6\$bLZbaeySMzRx7P29\$cmmF4SbtnXe2Gc1cBc0fpnBUEPxrr8inn6SNq9xpcT7M/vM0FpZmGF105LWrGCValjJMqEtBALZOYayppwJAj}) }
  end

  describe command('getent passwd newuser2 | cut -f5 -d:') do
    its(:stdout) { should match(/another new user/) }
  end

  describe file('/home/custom_home_directory/.ssh') do
    it { should be_directory }
    it { should be_mode 700 }
  end

  describe file('/home/custom_home_directory/.ssh/id_rsa') do
    it { should be_mode 600 }
  end

  describe file('/home/custom_home_directory/.ssh/id_rsa.pub') do
    it { should be_mode 644 }
  end

  describe command('chage -l newuser2') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/Last password change[[:space:]]+: Jul 30, 2015/) }
    its(:stdout) { should match(/Password expires[[:space:]]+: Sep 28, 2015/) }
    its(:stdout) { should match(/Account expires[[:space:]]+: Sep 30, 2035/) }
    its(:stdout) { should match(/Minimum number of days between password change[[:space:]]+: 30/) }
    its(:stdout) { should match(/Maximum number of days between password change[[:space:]]+: 60/) }
    its(:stdout) { should match(/Number of days of warning before password expires[[:space:]]+: 5/) }
  end

  describe file('/etc/sudoers.d/newuser2') do
    its(:content) { should match(%r{newuser2 ALL=\(root\) NOPASSWD\:/etc/init.d/httpd restart}) }
    its(:content) { should match(%r{newuser2 ALL=\(root\) NOPASSWD\:/sbin/iptables}) }
    its(:content) { should match(/Defaults:newuser2 !requiretty,env_reset/) }
  end
end

shared_examples_for 'users override' do
  # olduser
  describe user('olduser') do
    it { should_not exist }
  end
  describe file('/etc/sudoers.d/olduser') do
    it { should_not exist }
  end

  # newuser1
  describe user('newuser1') do
    it { should exist }
    it { should belong_to_group 'newuser1' }
    it { should belong_to_group 'web' }
    it { should belong_to_group 'marketing' }
    it { should belong_to_group 'facilities' }
    it { should belong_to_group 'staging' }
  end

  describe file('/etc/sudoers.d/newuser1') do
    it { should exist }
    its(:content) { should match(/newuser1 ALL=\(ALL\) ALL/) }
  end

  # newuser2
  describe user('newuser2') do
    it { should exist }
    it { should belong_to_group 'newuser2' }
    it { should belong_to_group 'web' }
    it { should belong_to_group 'marketing' }
    it { should belong_to_group 'facilities' }
    it { should belong_to_group 'staging' }
  end

  describe file('/etc/sudoers.d/newuser2') do
    it { should_not exist }
  end

  # newuser3
  describe user('newuser3') do
    it { should_not exist }
  end

  # Groups
  %w[web marketing facilities staging].each do |group|
    describe group(group) do
      it { should exist }
    end
  end
  describe group('inventory') do
    it { should_not exist }
  end
end
