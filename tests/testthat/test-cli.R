datapackage_path <- "../data/datapackage.json"
breeding_status_path <- "../data/breeding_status_albatross_guadalupe.csv"
tracking_path <- "../data/gps-albatros-guadalupe.csv"

describe("write_bl_table", {
  it("construct_bl_table ", {
    relative_path <- paste0(getwd(), "/../data/")
    setwd(relative_path)
    output_path <- "bl_albatross_guadalupe.csv"
    datapackage_path <- "datapackage.json"
    testtools::if_exist_remove(output_path)
    write_bl_table(datapackage_path, output_path)
    expect_true(testtools::exist_output_file(output_path))
  })
})
