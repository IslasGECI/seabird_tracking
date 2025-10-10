# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added

### Fixed

### Changed

### Removed

## [1.1.1] - 2025-10-10
### Added
- Deprecation warning for `write_bl_table()` function.

### Fixed
- `classify_breed_stage()` takes into account "breeding fail" option.
- `construct_bl_table()` round coordinates to 6 decimal places to avoid floating point issues.

## [1.1.0] - 2025-09-09
### Added
- `classify_breed_stage()` use the hatching and brood end dates to classify

### Fixed
- `join_seabird_breeding_status_with_tracking_data()` now can join between two calendar years for the same albatros nesting season.

## [1.0.0] - 2024-04-04

### Added
- CLI function `clean_gps()` read csv and txt files

### Removed
- `clean_gps_from_txt()` deprecated. Use `clean_gps()` with `.txt` file instead.

[unreleased]: https://github.com/IslasGECI/templater/compare/v1.1.1...HEAD
[1.1.0]: https://github.com/IslasGECI/templater/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/IslasGECI/templater/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/IslasGECI/templater/releases/tag/v1.0.0
