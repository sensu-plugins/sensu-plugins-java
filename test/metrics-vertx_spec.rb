require_relative './spec_helper.rb'
require_relative '../bin/metrics-vertx'
require_relative './fixtures.rb'

describe 'MetricsVertX' do
  before do
    MetricsVertX.class_variable_set(:@@autorun, false)
  end

  describe 'with positive answer' do
    before do
      @default_parameters = '--scheme=test'
      @metrics = MetricsVertX.new(@default_parameters.split(' '))
      allow(@metrics).to receive(:request).and_return(vertx_metrics)
      allow(@metrics).to receive(:ok)
    end

    describe '#run' do
      it 'tests that a metrics are ok' do
        @output_result = {}
        allow(@metrics).to receive(:output).and_wrap_original do |_m, *args|
          @output_result[args[0]] = args[1]
        end

        @metrics.run
        expect(@output_result['test.vertx.http.servers.0.0.0.0:8080.requests.timer.count']).to eq 526
        expect(@output_result['test.vertx.pools.worker.vert.x-worker-thread.pool-ratio.gauge.value']).to eq 0
        expect(@output_result['test.vertx.http.clients.responses-1xx.meter.count']).to eq 0
        expect(@output_result['test.vertx.http.clients.connections.timer.count']).to eq 6
        expect(@output_result['test.vertx.http.servers.0.0.0.0:8080.bytes-read.histogram.count']).to eq 526
      end
    end
  end
end
