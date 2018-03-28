require_relative './spec_helper.rb'
require_relative '../bin/check-vertx-health'
require_relative './fixtures.rb'

describe 'CheckVertXHealth' do
  before do
    CheckVertXHealth.class_variable_set(:@@autorun, false)
  end

  describe 'with positive answer' do
    before do
      @check = CheckVertXHealth.new
      allow(@check).to receive(:request).and_return(vertx_health_good_response)
    end

    describe '#run' do
      it 'tests that a check are ok' do
        expect(@check).to receive(:ok).with('VertX is UP')

        @check.run
      end
    end
  end

  describe 'with negative answer' do
    before do
      @check = CheckVertXHealth.new
      allow(@check).to receive(:request).and_return(vertx_health_bad_response)
    end

    describe '#run' do
      it 'tests that a check are ok' do
        expect(@check).to receive(:warning).with('VertX is DOWN')

        @check.run
      end
    end
  end

  describe 'can not receive answer' do
    before do
      @check = CheckVertXHealth.new
      allow(@check).to receive(:request).and_raise(StandardError, 'error')
    end

    describe '#run' do
      it 'tests that a check are ok' do
        expect(@check).to receive(:critical).with('error')

        @check.run
      end
    end
  end
end
