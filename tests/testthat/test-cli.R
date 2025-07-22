describe("write_bl_table", {
  it("construct_bl_table ", {
    relative_path <- "/workdir/tests/data"
    setwd(relative_path)
    output_path <- "bl_albatross_guadalupe.csv"
    datapackage_path <- "datapackage.json"
    testtools::if_exist_remove(output_path)
    write_bl_table(datapackage_path, output_path)
    expect_true(testtools::exist_output_file(output_path))
  })
})
