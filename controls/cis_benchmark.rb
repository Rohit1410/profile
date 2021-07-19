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
