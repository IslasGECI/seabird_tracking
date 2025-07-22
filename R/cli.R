#' @export
write_bl_table <- function(options) {
  breeding_status <- read_csv(options[["breeding-status"]], show_col_types = FALSE)
  tracking_data <- read_csv(options[["tracking-data"]], show_col_types = FALSE)
  bl_table <- construct_bl_table(breeding_status, tracking_data)
  write_csv(bl_table, options[["output-path"]])
}
