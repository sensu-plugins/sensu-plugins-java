#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
## Fixed
- CHANGELOG issues because 0.0.5 was never released
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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.6...HEAD
[0.0.6]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.5...0.0.6
[0.0.5]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.4...0.0.5
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.1...0.0.2
