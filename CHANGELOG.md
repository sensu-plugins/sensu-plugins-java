# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
### Breaking Changes
- dropped ruby 2.1 support (@yuri-zubov sponsored by Actility, https://www.actility.com)
- added `rest-client` as a dependency which requires you to have a local c compiler present to install this plugin (@yuri-zubov sponsored by Actility, https://www.actility.com)

### Security
- updated yard dependency to `~> 0.9.11` per: https://nvd.nist.gov/vuln/detail/CVE-2017-17042 (@yuri-zubov sponsored by Actility, https://www.actility.com)
- updated rubocop dependency to `~> 0.51.0` per: https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8418. (@yuri-zubov sponsored by Actility, https://www.actility.com)

### Added
- Added ability to get metrics from VertX (@yuri-zubov sponsored by Actility, https://www.actility.com)
- Added health-check VertX (@yuri-zubov sponsored by Actility, https://www.actility.com)

## [1.3.0] - 2017-09-05
### Added
- option `-l` to change if you wish to grab the max or the current heap limits (@Juan-Moreno)

## [1.2.0] - 2017-08-20
### Added
- check-java-permgen.rb: added an option to specify java bin dir (@sovaa)

## [1.1.0] - 2017-08-12
### Added
- check-java-permgen.rb: added an option to run `jps` and `jstsat` with sudo (@sovaa)

## [1.0.0] - 2017-07-24
### Breaking Changes
- Minimum Ruby runtime version is now 2.0 (@eheydrick)

### Added
- ruby 2.3 testing on release (@majormoses)
- ruby 2.4.1 testing (@majormoses)

### Removed
- Ruby 1.9.3 from deploy-time testing (@eheydrick)

### Fixed
- CHANGELOG issues because 0.0.5 was never released (@majormoses)


## [0.0.6] - 2017-06-09
### Changed
- refactor of check-java-heap-pcnt.sh, metrics-java-heap-graphite.sh made java version agnostic. jstat -gc returns 17 columns and has metaspace in java8. jstat -gc returns 15 columns and has permgen space in java 7, 6. These will work for both versions.
- run jstat only once for performance improvement
- Fix issue #11.
- java-heap-pcnt, check-java-heap-pcnt-java8, metrics-java-heap-graphite-java8 could be removed in a future release

## [0.0.5] - 2016-11-02
### Changed
- metrics-jstat.py: support added for py2.6 (RHEL/CentOS 6.x)
- check-java-heap-pcnt.sh: add -j option to specify location of java binaries
- check-java-heap-pcnt.sh: add -o option to allow specifying command line arguments to jps

## [0.0.4] - 2016-04-26
### Changed
- metrics-jstat.py: run jps with the verbose flag to allow for matching on the entire command line
- rename java-heap-pcnt to check-java-heap-pcnt. java-heap-pcnt will be removed in a future release

### Added
- add binstubs for non-ruby scripts

### Fixed
- metrics-jstat.py: exit 0 on success

## [0.0.3] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## [0.0.2] - 2015-06-03
### Fixed
- added binstubs

### Changed
- removed cruft from /lib

## 0.0.1 - 2015-05-29

### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-java/compare/1.3.0...HEAD
[1.3.0]: https://github.com/sensu-plugins/sensu-plugins-java/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/sensu-plugins/sensu-plugins-java/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-java/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.6...1.0.0
[0.0.6]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.5...0.0.6
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.1...0.0.2
