#' @import dplyr
#' @import readr

construct_bl_table <- function(breeding_status, tracking_data) {
  data_table <- join_seabird_breeding_status_with_tracking_data(breeding_status, tracking_data) |>
    mutate(track_id = bird_id, age = "adult", equinox = NA, argos_quality = NA)
  colony_df <- tibble::tibble(Longitude = -118.29162, Latitude = 28.88421)
  config_content <- list(inner_buff = 60, return_buff = 60, duration = 1, colony = colony_df)
  ordered_columns <- c(
    "bird_id",
    "sex",
    "age",
    "breed_stage",
    "track_id",
    "date_gmt",
    "time_gmt",
    "latitude",
    "longitude",
    "equinox",
    "argos_quality"
  )
  data_table_with_trips <- data_table |>
    classify_breed_stage() |>
    bycatch::get_trips(config_content)

  data_table_with_trips@data |>
    rename(time_gmt = time, latitude = Latitude, longitude = Longitude, track_id = tripID) |>
    select(all_of(ordered_columns))
}

join_seabird_breeding_status_with_tracking_data <- function(breeding_status, tracking_data) {
  tracking_data_with_season <- tracking_data |> mutate(season = lubridate::year(date))
  right_join(breeding_status, tracking_data_with_season, by = join_by("bird_id" == "name", "season" == "season")) |>
    rename(date_gmt = date, lat_colony = nest_lat, lon_colony = nest_lon)
}
classify_breed_stage <- function(data) {
  data |>
    mutate(breed_stage = case_when(
      date_gmt < hatching_end_date ~ "incubation",
      date_gmt < brood_end_date & date_gmt >= hatching_end_date ~ "brood-guard",
      date_gmt >= brood_end_date ~ "chick-rearing"
    ))
}


get_metadata_path <- function(datapackage_path, resource_name = resource_name) {
  resource <- get_resource(datapackage_path, resource_name)
  resource$path[[1]]
}

get_resource <- function(datapackage_path, resource_name) {
  datapackage <- rjson::fromJSON(file = datapackage_path, simplify = FALSE)
  resource_index <- which(sapply(datapackage$resources, function(x) resource_name %in% x))
  resource <- datapackage$resources[[resource_index]]
}
