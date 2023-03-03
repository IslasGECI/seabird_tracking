library(tidyverse)

describe("Join data columns", {
  breeding_status <- read_csv("../data/breeding_status_albatross_guadalupe.csv")
  tracking_data <- read_csv("../data/gps-albatros-guadalupe.csv")
  obtained <- join_seabird_breeding_status_with_tracking_data(breeding_status, tracking_data)
  it("Check columns", {
    expected_columns <- c(
      "bird_id",
      "track_id",
      "original_track_id",
      "sex",
      "lat_colony",
      "lon_colony",
      "breed_stage",
      "breed_status",
      "date_gmt",
      "time_gmt",
      "longitude",
      "latitude",
      "argos_quality"
    )
    obtained_columns <- colnames(obtained)
    expect_true(all(obtained_columns %in% expected_columns))
    expected_number_columns <- length(expected_columns)
    obtained_number_columns <- length(obtained_columns)
    expect_equal(obtained_number_columns, expected_number_columns)
  })
  it("Check rows", {
    obtained_rows_LAAL01 <- nrow(filter(obtained, bird_id == "LAAL01"))
    expected_rows_LAAL01 <- 3
    expect_equal(obtained_rows_LAAL01, expected_rows_LAAL01)
    obtained_rows <- nrow(obtained)
    expected_rows <- 29
    expect_equal(obtained_rows, expected_rows)
  })
})
describe("Fill metadata data columns", {
  it("Check columns", {
    expected_columns <- c(
      "common_name",
      "site_name",
      "colony_name",
      "device"
    )
    datapackage_path <- "../data/datapackage.json"
    obtained_metadata <- get_metadata(datapackage_path)
    obtained_columns <- colnames(obtained_metadata)
    expect_equal(obtained_columns, expected_columns)
    obtained_metadata <- obtained_metadata
    expected_metadata <- tibble(common_name = "Laysan albatross", site_name = "Mexico", colony_name = "Isla Guadalupe", device = "GPS")
    expect_equal(obtained_metadata, expected_metadata)
  })
  it("Test read new datapackage", {
    datapackage_path <- "../data/datapackage_pardela.json"
    resource_name <- "breeding_status_pardela_honolulu"
    obtained <- get_metadata(datapackage_path, resource_name = resource_name)
    obtained_site_name <- obtained$site_name[[1]]
    expected_site_name <- "USA"
    expect_equal(obtained_site_name, expected_site_name)
  })
})
