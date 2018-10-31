require 'spec_helper'

describe 'nrpe' do
  let :facts do
    { osfamily: 'RedHat',
      architecture: 'x86_64' }
  end

  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_package('nrpe').with_ensure('installed') }
  it { is_expected.to contain_package('nagios-plugins-all').with_ensure('installed') }
  it { is_expected.to contain_service('nrpe').with_ensure('running') }
  it { is_expected.to contain_concat('/etc/nagios/nrpe.cfg') }
  it { is_expected.to contain_file('nrpe_include_dir').with_ensure('directory') }

  context 'when manage_package is false' do
    let(:params) { { manage_package: false } }

    it { is_expected.not_to contain_package('nrpe') }
  end

  context 'when ssl is being used' do
    let(:params) { { ssl_cert_file_content: 'cert file content' } }

    it { is_expected.to contain_concat_fragment('nrpe ssl fragment') }
  end
end
