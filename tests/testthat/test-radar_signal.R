describe("Assign coordinates to radar signal data", {
  it("with match on id and date time", {
    tracking_data <- tibble::tibble(
      name = c("4E8", "4E8", "4H2"),
      date = as.Date(c("2020-01-01", "2020-01-02", "2020-01-01")),
      time = c("12:00:00", "12:00:00", "12:00:00"),
      latitude = c(10, 20, 15),
      longitude = c(30, 40, 100)
    )
    radar_signal <- tibble::tibble(
      bird_id = "4E8",
      date = as.Date("2020-01-01"),
      time = "12:00:00",
      radar_signal = 3
    )
    obtained <- assign_coordinates_to_radar_signal(radar_signal, tracking_data)
    expected_columns <- c("name", "date", "time", "radar_signal", "latitude", "longitude")
    obtained_columns <- colnames(obtained)
    expect_true(all(expected_columns %in% obtained_columns))
    expect_equal(nrow(obtained), 1)
  })
  it("without match on id and date time should return no rows", {
    tracking_data <- tibble::tibble(
      name = c("4E8", "4E8", "4H2"),
      date = as.Date(c("2020-01-01", "2020-01-02", "2020-01-01")),
      time = c("12:00:00", "12:00:00", "12:00:00"),
      latitude = c(10, 20, 15),
      longitude = c(30, 40, 100)
    )
    radar_signal <- tibble::tibble(
      bird_id = "4E8",
      date = as.Date("2020-01-05"),
      time = "11:00:00",
      radar_signal = 3
    )
    obtained <- assign_coordinates_to_radar_signal(radar_signal, tracking_data)
    expected_rows <- 0
    expect_equal(nrow(obtained), expected_rows)
  })
  it("Fill tracking data with missing records in radar signal data", {
    tracking_data <- tibble::tibble(
      name = c("4E8", "4E8", "4H2"),
      date = as.Date(c("2020-01-01", "2020-01-02", "2020-01-01")),
      time = c("12:00:00", "12:00:00", "12:00:00"),
      latitude = c(10, 20, 15),
      longitude = c(30, 40, 100)
    )
    radar_signal <- tibble::tibble(
      bird_id = c("4E8", "4H2"),
      date = as.Date(c("2020-01-01", "2020-01-02")),
      time = c("15:00:00", "12:00:00"),
      radar_signal = c(3, 10)
    )
    obtained <- fill_tracking_data_with_dates_on_radar_signal(radar_signal, tracking_data)
    expected_rows <- 4
    expect_equal(nrow(obtained), expected_rows)
    expected_ids <- c(rep("4E8", 3), "4H2")
    expect_equal(obtained$name, expected_ids)
  })
})
