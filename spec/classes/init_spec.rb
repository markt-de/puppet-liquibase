require 'spec_helper'
describe 'liquibase' do
  let :facts do
    {
      kernel: 'Linux',
      osfamily: 'RedHat',
      operatingsystem: 'CentOS',
      operatingsystemrelease: '6',
      operatingsystemmajrelease: '6',
      concat_basedir: '/dne',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      kernelmajversion: '2.6',
      is_virtual: 'true',
      fqdn: 'svq-nonexistant.domain',
      architecture: 'x64',
      selinux: true
    }
  end
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('liquibase') }
  end
end
