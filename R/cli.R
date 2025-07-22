#' @export
write_bl_table <- function(options) {
  breeding_status <- read_csv(options[["breeding-status-path"]], show_col_types = FALSE)
  tracking_data <- read_csv(options[["tracking-data-path"]], show_col_types = FALSE)
  config_content <- read_config(options[["config-path"]])
  bl_table <- construct_bl_table(breeding_status, tracking_data, config_content)
  write_csv(bl_table, options[["output-path"]])
}

#' @export
get_domain_specific_options <- function() {
  breeding_status_path <- geci.optparse::character_option(c("-b", "--breeding-status-path"), default = "/workdir/breeding_status.csv", help = "File path of the breeding_status_database")
  tracking_path <- geci.optparse::character_option(c("-c", "--tracking-data-path"), default = "/workdir/gps-albatros-guadalupe.csv", help = "File path of the tracking database")
  config_path <- geci.optparse::character_option(c("-c", "--config-path"), default = "/workdir/reports/non-tabular/config_file.json", help = "File path of the configuration")
  output_path <- geci.optparse::character_option(c("-o", "--output-path"), default = "/workdir/reports/tables/result.csv", help = "File path of the desire output")
  option_names <- c(breeding_status_path, tracking_path, config_path, output_path)
  geci.optparse::get_options_from_vec(option_names)
}

read_config <- function(config_path) {
  json_content <- rjson::fromJSON(file = config_path)
  json_content$colony <- tibble::tibble(Longitude = json_content$lon_colony, Latitude = json_content$lat_colony)
  return(json_content)
}
