<a href="https://www.islas.org.mx"><img src="https://www.islas.org.mx/img/logo.svg" align="right" width="256" /></a>

[![codecov](https://codecov.io/gh/IslasGECI/seabird_tracking/graph/badge.svg?token=SqCWLV6rCr)](https://codecov.io/gh/IslasGECI/seabird_tracking)
[![example branch parameter](https://github.com/IslasGECI/seabird_tracking/actions/workflows/actions.yml/badge.svg)](https://github.com/IslasGECI/seabirdtracking/actions/workflows/actions.yml)
[![licencia](https://img.shields.io/github/license/IslasGECI/seabird_tracking)](https://img.shields.io/github/license/IslasGECI/seabirdtracking)
[![languages](https://img.shields.io/github/languages/top/IslasGECI/seabird_tracking)](https://img.shields.io/github/languages/top/IslasGECI/seabirdtracking)
[![commits](https://img.shields.io/github/commit-activity/y/IslasGECI/seabird_tracking)](https://img.shields.io/github/commit-activity/y/IslasGECI/seabirdtracking)
[![GitHub contributors](https://img.shields.io/github/contributors/IslasGECI/seabird_tracking)](https://img.shields.io/github/contributors/IslasGECI/seabirdtracking)
[![R-version](https://img.shields.io/github/r-package/v/IslasGECI/seabird_tracking)](https://img.shields.io/github/r-package/v/IslasGECI/seabirdtracking)

# Seabird Tracking Data Processing

**seabirdtracking** is a set of utilities to process raw seabird tracking data and construct standardized datasets for the Seabird Tracking Database. It supports GPS/GLS point extraction, radar signal coordinate enrichment, and BirdLife table generation.

## Functions

| Function | Description |
|---|---|
| `write_radar_signal_coordinates(options)` | Reads tracking and radar signal CSVs, enriches radar signals with interpolated GPS coordinates via `compute_radar_signal_database()`, filters by noise threshold, and writes output CSV. |
| `write_birdlife_table(options)` | Reads breeding status, tracking data, and a JSON config, computes trips via `bycatch::compute_trips()`, constructs a BirdLife-format table, and writes output CSV. |
| `clean_gps(raw_path, bird_id)` | Extracts GPS points from raw `.txt` or `.csv` files and writes a cleaned CSV with bird ID. |
