describe("write_bl_table", {
  it("construct_bl_table ", {
    output_path <- "/workdir/tests/data/bl_albatross_guadalupe.csv"
    config_path <- "/workdir/tests/data/trips_config.json"
    testtools::if_exist_remove(output_path)
    options_list <- list(
      "config-path" = config_path,
      "breeding-status-path" = "/workdir/tests/data/breeding_status_albatross_guadalupe.csv",
      "tracking-data-path" = "/workdir/tests/data/gps-albatros-guadalupe.csv",
      "output-path" = output_path
    )
    write_birdlife_table(options_list)
    expect_true(testtools::exist_output_file(output_path))
  })
})
describe("get_domain_specific_options", {
  it("Defines domain specific options", {
    obtained_options <- get_domain_specific_options()
    expected_options <- c("config-path", "breeding-status-path", "tracking-data-path", "output-path")
    expect_true(all(expected_options %in% names(obtained_options)))
  })
})
