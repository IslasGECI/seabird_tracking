#' @import dplyr

join_seabird_breeding_status_with_tracking_data <- function(breeding_status, tracking_data) {
  right_join(breeding_status, tracking_data, by = c("bird_id" = "name")) |>
    rename(date_gmt = date, lat_colony = nest_lat, lon_colony = nest_lon) |>
    mutate(track_id = bird_id, original_track_id = bird_id, time_gmt = NA, argos_quality = NA)
}

get_metadata <- function(datapackage_path, resource_name = "breeding_status_albatross_guadalupe") {
  datapackage <- rjson::fromJSON(file = datapackage_path, simplify = FALSE)
  resource_index <- which(sapply(datapackage$resources, function(x) resource_name %in% x))
  resource <- datapackage$resources[[resource_index]]
  tibble(
    common_name = resource$common_name,
    site_name = resource$site_name,
    colony_name = resource$colony_name,
    device = resource$device
  )
}
