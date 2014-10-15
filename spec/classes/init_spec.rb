require 'spec_helper'
describe 'puppet_redbox_admin' do

  context 'with defaults for all parameters' do
    it { should contain_class('puppet_redbox_admin') }
  end
end
