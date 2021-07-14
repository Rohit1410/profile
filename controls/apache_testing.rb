control 'apache-package' do
  impact 1.0
  title 'this control is to ensure apache package is installed'
  desc '
    In order webserver to run apache service should be running
  '
  describe package('apache2') do
    it { should be_installed }
  end
end

title 'Apache server config'
only_if do
  upstart_service('apache2').installed?
end
title 'Apache server config'
control 'apache-01' do
  impact 1.0
  title 'Apache should be running'
  desc 'Apache should be running.'
  describe upstart_service('apache2') do
    it { should be_installed }
    it { should be_running }
  end
end

control 'apache-04' do
  impact 1.0
  title 'Check Apache config folder owner, group and permissions.'
  desc 'The Apache config folder should owned and grouped by root, be writable, readable and executable by owner. It should be readable, executable by group and not readable, not writeable by others.'
  describe file('/etc/apache2') do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_readable.by('owner') }
    it { should be_writable.by('owner') }
    it { should be_executable.by('owner') }
    it { should be_readable.by('owner') }
    it { should_not be_writable.by('group') }
    it { should be_executable.by('group') }
    it { should_not be_writable.by('others') }
    it { should be_executable.by('others') }
  end
end

control 'apache-06' do
  impact 1.0
  title 'User and group should be set properly'
  desc 'For security reasons it is recommended to run Apache in its own non-privileged account.'
  describe users.where { username =~ /apache/ } do
    it { should exist }
  end
end
