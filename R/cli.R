#' @export
write_bl_table <- function(options) {
  breeding_status <- read_csv(options[["breeding-status"]], show_col_types = FALSE)
  tracking_data <- read_csv(options[["tracking-data"]], show_col_types = FALSE)
  config_content <- read_config(options[["config-path"]])
  bl_table <- construct_bl_table(breeding_status, tracking_data, config_content)
  write_csv(bl_table, options[["output-path"]])
}

read_config <- function(config_path) {
  json_content <- rjson::fromJSON(file = config_path)
  json_content$colony <- tibble::tibble(Longitude = json_content$lon_colony, Latitude = json_content$lat_colony)
  return(json_content)
}
