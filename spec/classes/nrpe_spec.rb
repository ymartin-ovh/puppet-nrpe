require 'spec_helper'

describe 'nrpe' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('nrpe::params') }
      it { is_expected.to contain_class('nrpe::install') }
      it { is_expected.to contain_class('nrpe::config').that_requires('Class[nrpe::install]') }
      it { is_expected.to contain_class('nrpe::service').that_subscribes_to('Class[nrpe::config]') }
    end
  end
end
