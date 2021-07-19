  control 'ssh-check' do
    impact 1.0
    title '/etc/ssh should be a directory'
    desc '
      In order for OpenSSH to function correctly, its
      configuration path must be a folder.
    '
    describe file('/etc/ssh') do
      it { should be_directory }
    end
  end
  
  control 'cis-dil-benchmark-1.1.15' do
    title 'Ensure nodev option set on /dev/shm partition'
    desc  "The nodev mount option specifies that the filesystem cannot contain special devices.
    Since the /run/shm filesystem is not intended to support devices, set this option to ensure 
    that users cannot attempt to create special devices in /dev/shm partitions."
    impact 1.0
  
    tag cis: 'distribution-independent-linux:1.1.15'
    tag level: 1
  
    only_if('/dev/shm is mounted') do
      mount('/dev/shm').mounted?
    end
  
    describe mount('/dev/shm') do
      its('options') { should include 'nodev' }
    end
  end
  
  control 'cis-dil-benchmark-1.7.1.4' do
    title 'Ensure permissions on /etc/motd are configured'
    desc  "The contents of the /etc/motd file are displayed to users after 
    login and function as a message of the day for authenticated users.
    If the /etc/motd file does not have the correct ownership it could be 
    modified by unauthorized users with incorrect or misleading information."
    impact 0.0
  
    tag cis: 'distribution-independent-linux:1.7.1.4'
    tag level: 1
  
    describe file('/etc/motd') do
      its('group') { should eq 'root' }
      its('owner') { should eq 'root' }
      its('mode') { should cmp '0644' }
    end
  end


  title '5.2 SSH Server Configuration'
  control 'cis-dil-benchmark-5.2.1' do
    title 'Ensure permissions on /etc/ssh/sshd_config are configured (Scored)'
    desc  '
      The /etc/ssh/sshd_config file contains configuration specifications for sshd.
      The commandn below sets the owner and group of the file to root.
      Rationale: The /etc/ssh/sshd_config file needs to be protected from unauthorized changes by non-privileged users.
    '
    impact 1.0
    tag cis: 'distribution-independent-linux:5.2.1'
    describe file('/etc/ssh/sshd_config') do
      it { should exist }
      it { should_not be_writable.by 'group' }
      it { should_not be_executable.by 'group' }
      it { should_not be_writable.by 'other' }
      it { should_not be_executable.by 'other' }
      its('uid') { should cmp 0 }
      its('gid') { should cmp 0 }
    end
  end
