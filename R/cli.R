#' @export
write_bl_table <- function(options) {
  breeding_status <- read_csv(options[["breeding-status"]], show_col_types = FALSE)
  tracking_data <- read_csv(options[["tracking-data"]], show_col_types = FALSE)
  colony_df <- tibble::tibble(Longitude = -118.29162, Latitude = 28.88421)
  config_content <- list(inner_buff = 60, return_buff = 60, duration = 1, colony = colony_df)
  bl_table <- construct_bl_table(breeding_status, tracking_data, config_content)
  write_csv(bl_table, options[["output-path"]])
}
