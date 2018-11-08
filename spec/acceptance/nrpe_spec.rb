require 'spec_helper_acceptance'

describe 'nrpe class' do
  case fact('osfamily')
  when 'Debian'
    package_name = 'nagios-nrpe-server'
    service_name = 'nagios-nrpe-server'
  else
    service_name = 'nrpe'
    package_name = 'nrpe'
  end
  config_file = '/etc/nagios/nrpe.cfg'

  describe 'default installation' do
    it 'works with no errors' do
      apply_manifest('include nrpe', catch_failures: true)
      apply_manifest('include nrpe', catch_changes: true)
    end

    describe package(package_name) do
      it { is_expected.to be_installed }
    end

    describe command('nrpe --version') do
      its(:stdout) { is_expected.to match %r{Nagios Remote Plugin Executor} }
    end

    describe file(config_file) do
      it { is_expected.to be_a_file }
    end

    describe service(service_name) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(5666) do
      it { is_expected.to be_listening }
    end
  end

  describe 'with custom server port' do
    it 'updates without errors' do
      pp = <<-EOS
      class { 'nrpe':
        server_port => 9999,
      }
      EOS
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe port(5666) do
      it { is_expected.not_to be_listening }
    end

    describe port(9999) do
      it { is_expected.to be_listening }
    end
  end
end
