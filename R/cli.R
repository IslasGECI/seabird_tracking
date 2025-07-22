#' @export
write_bl_table <- function(datapackage_path = "datapackage.json", output_path = "bl_gps_albatross_guadalupe.csv") {
  breeding_status_path <- get_metadata_path(datapackage_path, "breeding_status_albatross_guadalupe")
  tracking_path <- get_metadata_path(datapackage_path, "gps-albatros-guadalupe")
  breeding_status <- read_csv(breeding_status_path, show_col_types = FALSE)
  tracking_data <- read_csv(tracking_path, show_col_types = FALSE)
  bl_table <- xxconstruct_bl_table(breeding_status, tracking_data)
  write_csv(bl_table, output_path)
}
