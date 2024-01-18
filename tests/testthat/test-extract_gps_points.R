describe("extract gps for each file", {
  it("read tsv", {
    raw_path <- "/workdir/tests/data/raw_gps_albatros.txt"
    obtained_points <- extract_points(raw_path)
    obtained_number_of_columns <- ncol(obtained_points)
    expected_number_of_columns <- 4
    expect_equal(obtained_number_of_columns, expected_number_of_columns)

    obtained_number_of_rows <- nrow(obtained_points)
    expected_number_of_rows <- 16
    expect_equal(obtained_number_of_rows, expected_number_of_rows)
  })
})
