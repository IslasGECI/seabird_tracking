#' @import dplyr
#' @import readr

construct_bl_table <- function(breeding_status_path, tracking_path, datapackage_path) {
  breeding_status <- read_csv(breeding_status_path, show_col_types = FALSE)
  tracking <- read_csv(tracking_path, show_col_types = FALSE) |>
    mutate(season = lubridate::year(date), age = "adult", equinox = NA)
  data_table <- join_seabird_breeding_status_with_tracking_data(breeding_status, tracking)
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
    "original_track_id",
    "equinox",
    "argos_quality"
  )
  data_table |>
    select(all_of(ordered_columns))
}

join_seabird_breeding_status_with_tracking_data <- function(breeding_status, tracking_data) {
  tracking_data_with_season <- tracking_data |> mutate(season = lubridate::year(date))
  right_join(breeding_status, tracking_data_with_season, by = join_by("bird_id" == "name", "season" == "season")) |>
    rename(date_gmt = date, lat_colony = nest_lat, lon_colony = nest_lon) |>
    mutate(track_id = bird_id, original_track_id = bird_id, time_gmt = NA, argos_quality = NA)
}
classify_breed_stage <- function(data) {
  data |>
    mutate(breed_stage = case_when(
      date_gmt < hatching_end_date ~ "incubation",
      date_gmt < brood_end_date & date_gmt >= hatching_end_date ~ "brood-guard",
      date_gmt >= brood_end_date ~ "chick-rearing"
    ))
}

get_metadata <- function(datapackage_path, resource_name = "breeding_status_albatross_guadalupe") {
  resource <- get_resource(datapackage_path, resource_name)
  tibble(
    common_name = resource$common_name,
    site_name = resource$site_name,
    colony_name = resource$colony_name,
    device = resource$device
  )
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
