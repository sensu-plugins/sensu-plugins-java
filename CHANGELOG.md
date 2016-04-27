#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.3...HEAD
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-java/compare/0.0.1...0.0.2
