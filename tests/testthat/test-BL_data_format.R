library(tidyverse)


datapackage_path <- "/workdir/tests/data/datapackage.json"
breeding_status_path <- "/workdir/tests/data/breeding_status_albatross_guadalupe.csv"
tracking_path <- "/workdir/tests/data/gps-albatros-guadalupe.csv"

describe("Construct BL table", {
  it("construct_bl_table ", {
    breeding_status <- read_csv(breeding_status_path, show_col_types = FALSE)
    tracking_data <- read_csv(tracking_path, show_col_types = FALSE)
    obtained_bl_table <- construct_bl_table(breeding_status, tracking_data)
    expected_columns <- c(
      "bird_id",
      "sex",
      "age",
      "breed_stage",
      "track_id",
      "date_gmt",
      "time_gmt",
      "latitude",
      "longitude",
      "original_track_id",
      "equinox",
      "argos_quality"
    )
    obtained_columns <- colnames(obtained_bl_table)
    expect_true(all(expected_columns %in% obtained_columns))
  })
})
describe("Join data columns", {
  breeding_status <- read_csv(breeding_status_path, show_col_types = FALSE)
  tracking_data <- read_csv(tracking_path, show_col_types = FALSE)
  obtained <- join_seabird_breeding_status_with_tracking_data(breeding_status, tracking_data)
  it("Check columns", {
    obtained_columns <- colnames(obtained)
    expected_number_columns <- length(tracking_data) + length(breeding_status) - 1
    obtained_number_columns <- length(obtained_columns)
    expect_equal(obtained_number_columns, expected_number_columns)
  })
  it("Check rows", {
    obtained_rows_LAAL01 <- nrow(filter(obtained, bird_id == "LAAL01"))
    expected_rows_LAAL01 <- 3
    expect_equal(obtained_rows_LAAL01, expected_rows_LAAL01)
    obtained_rows <- nrow(obtained)
    expected_rows <- 33
    expect_equal(obtained_rows, expected_rows)
    obtained_rows_LAAL06 <- nrow(filter(obtained, bird_id == "LAAL06"))
    expected_rows_LAAL06 <- 0
    expect_equal(obtained_rows_LAAL06, expected_rows_LAAL06)
  })
})
describe("Classify breed stage from hatching and brood dates", {
  data <- tibble::tibble(
    bird_id = rep("LAAL1", 5),
    hatching_end_date = rep("2017-01-17", 5),
    brood_end_date = rep("2017-02-13", 5),
    date_gmt = c("2017-01-15", "2017-02-01", "2017-02-20", "2017-01-17", "2017-02-13")
  )
  obtained <- classify_breed_stage(data)
  it("Classify incubation", {
    obtained_breed_stage <- obtained[[1, "breed_stage"]]
    expect_equal(obtained_breed_stage, "incubation")
  })
  it("Classify brood-guard", {
    obtained_breed_stage <- obtained[[2, "breed_stage"]]
    expect_equal(obtained_breed_stage, "brood-guard")
  })
  it("Classify brood-guard", {
    obtained_breed_stage <- obtained[[3, "breed_stage"]]
    expect_equal(obtained_breed_stage, "chick-rearing")
  })
  it("Classify limit case: date equal to hatching end date", {
    obtained_breed_stage <- obtained[[4, "breed_stage"]]
    expect_equal(obtained_breed_stage, "brood-guard")
  })
  it("Classify limit case: date equal to brood end date", {
    obtained_breed_stage <- obtained[[5, "breed_stage"]]
    expect_equal(obtained_breed_stage, "chick-rearing")
  })
})
describe("Fill metadata data columns", {
  it("Test read metadata from gps-albatross", {
    resource_name <- "gps-albatros-guadalupe"
    obtained_metadata <- get_metadata_path(datapackage_path, resource_name = resource_name)
    obtained_path <- obtained_metadata
    expected_path <- "gps-albatros-guadalupe.csv"
    expect_equal(obtained_path, expected_path)
  })
})
