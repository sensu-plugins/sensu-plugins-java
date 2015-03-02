## Sensu-Plugins-java

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-java.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-java)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-java.svg)](http://badge.fury.io/rb/sensu-plugins-java)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-java/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-java)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-java/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-java)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-java.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-java)

## Functionality

## Files
 * bin/check-java-permgen
 * bin/java-heap-pcnt.sh
 * bin/metrics-java-heap-graphite
 * bin/metrics-jstat

## Usage

## Installation

Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install sensu-plugins-java -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-java`

#### Bundler

Add *sensu-plugins-disk-checks* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-java' do
  options('--prerelease')
  version '0.0.1.alpha.4'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-java' do
  options('--prerelease')
  version '0.0.1.alpha.4'
end
```

## Notes

[1]:[https://travis-ci.org/sensu-plugins/sensu-plugins-java]
[2]:[http://badge.fury.io/rb/sensu-plugins-java]
[3]:[https://codeclimate.com/github/sensu-plugins/sensu-plugins-java]
[4]:[https://codeclimate.com/github/sensu-plugins/sensu-plugins-java]
[5]:[https://gemnasium.com/sensu-plugins/sensu-plugins-java]
