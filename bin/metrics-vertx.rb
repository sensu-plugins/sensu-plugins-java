#! /usr/bin/env ruby
#
# metrics-vertx
#
# DESCRIPTION:
#  metrics-vertx get metrics from VertX
#
# OUTPUT:
#   metric-data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: rest-clien
#
# USAGE:
#
#
# NOTES:
#
# LICENSE:
#   Zubov Yuri <yury.zubau@gmail.com> sponsored by Actility, https://www.actility.com
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'rest-client'
require 'json'

class MetricsVertX < Sensu::Plugin::Metric::CLI::Graphite
  include CommonVertX

  option :endpoint,
         short: '-p ENDPOINT',
         long: '--endpointn ENDPOINT',
         description: 'VertX Endpoint',
         default: 'http://localhost:8080/rest/metrics'

  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-S SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.vertx"

  def metrics
    response = request
    ::JSON.parse(response)
  end

  def run
    metrics.each do |key, metrics|
      type_of_metric = metrics.delete('type')
      metrics.each do |metric_name, value|
        output("#{config[:scheme]}.#{key}.#{type_of_metric}.#{metric_name}", value)
      end
    end
    ok
  end
end
