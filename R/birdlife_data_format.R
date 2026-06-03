#' @import dplyr
#' @import readr

construct_bl_table <- function(breeding_status, tracking_data, config_content) {
  computed_trips <- bycatch::compute_trips(tracking_data, config_content)@data
  xxconstruct_bl_table(breeding_status, computed_trips, config_content)
}


xxconstruct_bl_table <- function(breeding_status, computed_trips, config_content) {
  data_table <- join_seabird_breeding_status_with_tracking_data(breeding_status, computed_trips) |>
    mutate(age = "adult", equinox = NA, argos_quality = NA)
  data_table_with_trips <- data_table |>
    classify_breed_stage()

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
  data_table_with_trips |>
    rename(time_gmt = time, latitude = Latitude, longitude = Longitude) |>
    mutate(track_id = tripID) |>
    round_coordinates(6) |>
    select(all_of(ordered_columns))
}

round_coordinates <- function(data, digits = 6) {
  data |>
    mutate(latitude = round(latitude, digits), longitude = round(longitude, digits))
}

join_seabird_breeding_status_with_tracking_data <- function(breeding_status, tracking_data) {
  tracking_data_with_season <- tracking_data |>
    mutate(season = lubridate::year(date), month = lubridate::month(date)) |>
    mutate(named_season = case_when(
      month > 6 ~ glue::glue("{season}-{season+1}"),
      month <= 6 ~ glue::glue("{season-1}-{season}")
    ))
  breeding_status_with_named_season <- breeding_status |>
    mutate(named_season = glue::glue("{season - 1}-{season}"))
  right_join(breeding_status_with_named_season, tracking_data_with_season, by = join_by("bird_id" == "ID", "named_season" == "named_season")) |>
    rename(date_gmt = date, lat_colony = nest_lat, lon_colony = nest_lon)
}
classify_breed_stage <- function(data) {
  data |>
    mutate(breed_stage = case_when(
      is.na(hatching_end_date) & is.na(brood_end_date) ~ "breeding fail (breeding season)",
      date_gmt < hatching_end_date ~ "incubation",
      date_gmt >= hatching_end_date & is.na(brood_end_date) ~ "breeding fail (breeding season)",
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
