describe("Get version of the module", {
  it("The version is 1.3.3", {
    expected_version <- c("1.3.3")
    obtained_version <- packageVersion("seabirdtracking")
    version_are_equal <- expected_version == obtained_version
    expect_true(version_are_equal)
  })
})
