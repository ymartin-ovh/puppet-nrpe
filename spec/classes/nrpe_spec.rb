require 'spec_helper'

describe 'nrpe' do
  on_supported_os(facterversion: '3.6').each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('nrpe::params') }
      it { is_expected.to contain_class('nrpe::install') }
      it { is_expected.to contain_class('nrpe::config').that_requires('Class[nrpe::install]') }
      it { is_expected.to contain_class('nrpe::service').that_subscribes_to('Class[nrpe::config]') }

      context 'when commands parameter is used' do
        let(:params) do
          {
            'commands' => {
              'check_users' => {
                command: 'check_users -w 5 -c 10'
              },
              'check_load' => {
                command: 'check_load -r -w 0.75, 0.7, 0.65 -c 0.85, 0.8, 0.75'
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_nrpe__command_resource_count(2) }
      end
      context 'when plugins parameter is used' do
        let(:params) do
          {
            'plugins' => {
              'check_mem' => {
                ensure: 'present',
                source: 'puppet:///modules/site/nrpe/check_mem'
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to have_nrpe__plugin_resource_count(1) }
      end
    end
  end
end
