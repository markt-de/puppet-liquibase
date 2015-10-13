require 'spec_helper'
describe 'liquibase' do

  context 'with defaults for all parameters' do
    it { should contain_class('liquibase') }
  end
end
