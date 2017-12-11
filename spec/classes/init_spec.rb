require 'spec_helper'
describe 'liquibase' do

  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('liquibase') }
  end
end
