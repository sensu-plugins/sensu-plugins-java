#! /usr/bin/env ruby
#
# check-vertx-health
#
# DESCRIPTION:
#  check-vertx-health simple way to expose health checks for VertX
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: rest-client
#
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
require 'sensu-plugin/check/cli'
require 'rest-client'
require 'json'

class CheckVertXHealth < Sensu::Plugin::Check::CLI
  include CommonVertX

  option :endpoint,
         short: '-p ENDPOINT',
         long: '--endpointn ENDPOINT',
         description: 'VertX Endpoint',
         default: 'http://localhost:8080/rest/health'

  def check_health
    response = request

    result = JSON.parse(response)
    result['outcome']
  end

  def run
    result = check_health

    if result == 'UP'
      ok 'VertX is UP'
    elsif result == 'DOWN'
      warning 'VertX is DOWN'
    end
  rescue StandardError => e
    critical e.message
  end
end
