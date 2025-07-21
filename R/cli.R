#' @export
write_bl_table <- function(datapackage_path = "datapackage.json", output_path = "bl_gps_albatross_guadalupe.csv") {
  breeding_status_path <- get_metadata_path(datapackage_path, "breeding_status_albatross_guadalupe")
  tracking_path <- get_metadata_path(datapackage_path, "gps-albatros-guadalupe")
  bl_table <- construct_bl_table(breeding_status_path, tracking_path, datapackage_path)
  write_csv(bl_table, output_path)
}
