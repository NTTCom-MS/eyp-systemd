require 'spec_helper'
describe 'systemd' do

  context 'with defaults for all parameters' do
    it { should contain_class('systemd') }
  end
end
