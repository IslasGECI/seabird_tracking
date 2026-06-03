library(tidyverse)


datapackage_path <- "/workdir/tests/data/datapackage.json"
breeding_status_path <- "/workdir/tests/data/breeding_status_albatross_guadalupe.csv"
tracking_path <- "/workdir/tests/data/gps-albatros-guadalupe.csv"

describe("Construct BL table", {
  breeding_status <- read_csv(breeding_status_path, show_col_types = FALSE)
  tracking_data <- read_csv(tracking_path, show_col_types = FALSE)
  colony_df <- tibble::tibble(Longitude = -118.29162, Latitude = 28.88421)
  config_content <- list(inner_buff = 60, return_buff = 60, duration = 1, colony = colony_df)
  obtained_bl_table <- construct_bl_table(breeding_status, tracking_data, config_content)
  it("construct_bl_table ", {
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
      "equinox",
      "argos_quality"
    )
    obtained_columns <- colnames(obtained_bl_table)
    expect_true(all(expected_columns %in% obtained_columns))
  })
  are_all_rounded <- function(x, digits = 6) {
    all(round(x, digits) == x, na.rm = TRUE)
  }
  it("Round coordinates", {
    expect_true(are_all_rounded(obtained_bl_table$latitude, 6))
    expect_true(are_all_rounded(obtained_bl_table$longitude, 6))
  })
  it("Classify breed stage from joined data", {
    expected_breed_stage <- "chick-rearing"
    obtained_breed_stage <- obtained_bl_table[[1, "breed_stage"]]
    expect_equal(obtained_breed_stage, expected_breed_stage)
  })
  it("Classify trips", {
    expected_trip_id <- "4E8_01"
    obtained_trip <- obtained_bl_table |> filter(track_id == expected_trip_id)
    expect_equal(nrow(obtained_trip), 4)
  })
})
describe("Join data columns", {
  breeding_status <- read_csv(breeding_status_path, show_col_types = FALSE)
  computed_trips_path <- "/workdir/tests/data/computed_trips.csv"
  computed_trips <- read_csv(computed_trips_path, col_types = cols(ID = col_character()), show_col_types = FALSE)
  obtained <- join_seabird_breeding_status_with_tracking_data(breeding_status, computed_trips)
  print(obtained)
  it("Check columns", {
    obtained_columns <- colnames(obtained)
    expected_number_columns <- length(computed_trips) + length(breeding_status) + 2
    obtained_number_columns <- length(obtained_columns)
    expect_equal(obtained_number_columns, expected_number_columns)
    are_4E8_sex_with_na <- obtained |>
      filter(bird_id == "4E8") |>
      pull(sex) |>
      is.na()
    expect_false(any(are_4E8_sex_with_na))
  })
  it("Check rows", {
    obtained_rows_id_1 <- nrow(filter(obtained, bird_id == "1"))
    expected_rows_id_1 <- 2
    expect_equal(obtained_rows_id_1, expected_rows_id_1)
    obtained_rows <- nrow(obtained)
    expected_rows <- 17
    expect_equal(obtained_rows, expected_rows)
    obtained_rows_LAAL06 <- nrow(filter(obtained, bird_id == "LAAL06"))
    expected_rows_LAAL06 <- 0
    expect_equal(obtained_rows_LAAL06, expected_rows_LAAL06)
  })
})
describe("Classify breed stage from hatching and brood dates", {
  data <- tibble::tibble(
    bird_id = c(rep("LAAL1", 5), "LAAL10", "LAAL11"),
    hatching_end_date = c(rep("2017-01-17", 5), "2018-01-10", NA),
    brood_end_date = c(rep("2017-02-13", 5), NA, NA),
    date_gmt = c("2017-01-15", "2017-02-01", "2017-02-20", "2017-01-17", "2017-02-13", "2018-01-12", "2018-02-12")
  )
  obtained <- classify_breed_stage(data)
  it("Classify breeding fail", {
    obtained_breeding_fail <- obtained[[6, "breed_stage"]]
    expect_equal(obtained_breeding_fail, "breeding fail (breeding season)")

    obtained_breeding_fail <- obtained[[7, "breed_stage"]]
    expect_equal(obtained_breeding_fail, "breeding fail (breeding season)")
  })
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
