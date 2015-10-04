require 'spec_helper'

describe 'nrpe::plugin', :type => :define do

    let(:pre_condition) { 'include nrpe' }

    let :facts do
     { :osfamily => 'Debian', }
    end

    let (:title) {'check_users'}
    let :params do
      {
        :ensure  => 'present',
      }
    end

    it { should contain_file('/usr/lib/nagios/plugins/check_users') }
end
