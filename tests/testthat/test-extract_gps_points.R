describe("extract gps for each file", {
  raw_path <- "/workdir/tests/data/raw_gps_albatros.txt"
  it("clean gps", {
    bird_id <- "bird_1"
    clean_gps(raw_path, bird_id)
  })
})
describe("extract gps technosmart", {
  raw_path <- "/workdir/tests/data/raw_gps_albatros.txt"
  it("clean txt for each bird id", {
    bird_id <- "bird_1"
    output_path <- "/workdir/tests/data/cleaned_gps.csv"
    clean_gps_from_txt(raw_path, bird_id, output_path)
    obtained <- read_csv(output_path, show_col_types = FALSE)
    obtained_id <- obtained$bird_id[[1]]
    expect_equal(obtained_id, bird_id)
    obtained_date <- obtained$Date[[1]]
    expected_date <- as.Date("2014-01-25")
    expect_equal(obtained_date, expected_date)
    expect_true(testtools::exist_output_file(output_path))
  })
  it("read tsv", {
    obtained_points <- extract_points_from_txt(raw_path)
    obtained_number_of_columns <- ncol(obtained_points)
    expected_number_of_columns <- 4
    expect_equal(obtained_number_of_columns, expected_number_of_columns)

    obtained_number_of_rows <- nrow(obtained_points)
    expected_number_of_rows <- 16
    expect_equal(obtained_number_of_rows, expected_number_of_rows)
  })
})

describe("extract gps from i-gatU device", {
  raw_path <- "/workdir/tests/data/raw_gps_albatros_igatu.csv"
  it("clean csv for each bird id", {
    bird_id <- "bird_1"
    output_path <- "/workdir/tests/data/cleaned_gps_from_igatu.csv"
    testtools::delete_output_file(output_path)

    clean_gps_from_csv(raw_path, bird_id, output_path)
    obtained <- read_csv(output_path, show_col_types = FALSE)
    obtained_id <- last(obtained$bird_id)
    expect_equal(obtained_id, bird_id)

    obtained_date <- obtained$Date[[1]]
    expected_date <- as.Date("2017-02-15")
    expect_equal(obtained_date, expected_date)

    testtools::delete_output_file(output_path)
  })
  it("read csv", {
    obtained_points <- extract_points_from_csv(raw_path)
    obtained_columns <- colnames(obtained_points)
    expected_columns <- c("Date", "Time", "Longitude", "Latitude")
    expect_equal(obtained_columns, expected_columns)
  })
})
