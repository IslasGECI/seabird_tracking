describe("Assign coordinates to radar signal data", {
  it("with match on id and date time", {
    tracking_data <- tibble::tibble(
      name = c("4E8", "4E8"),
      date = as.Date(c("2020-01-01", "2020-01-02")),
      time = c("12:00:00", "12:00:00"),
      latitude = c(10, 20),
      longitude = c(30, 40)
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
})
