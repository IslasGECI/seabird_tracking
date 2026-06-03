assign_coordinates_to_radar_signal <- function(radar_signal, tracking_data) {
  radar_signal_with_coordinates <- radar_signal |>
    dplyr::left_join(tracking_data, by = dplyr::join_by(bird_id == name, date, time)) |>
    dplyr::rename(name = bird_id)
  radar_signal_with_coordinates |> tidyr::drop_na(latitude, longitude)
}

fill_tracking_data_with_dates_on_radar_signal <- function(radar_signal, tracking_data) {
  tracking_data_with_datetime <- add_datetime_column(tracking_data)

  radar_signal_with_datetime <- add_datetime_column(radar_signal)

  tracking_data_range_by_id <- tracking_data_with_datetime |>
    dplyr::group_by(name) |>
    dplyr::summarize(min_datetime = min(datetime), max_datetime = max(datetime))

  filtered_radar_signal <- filter_radar_signal_within_tracking_data_range(radar_signal_with_datetime, tracking_data_range_by_id)
  dplyr::bind_rows(tracking_data, filtered_radar_signal)
}
add_datetime_column <- function(data) {
  data_with_datetime <- data |>
    dplyr::mutate(datetime = lubridate::ymd_hms(paste0(date, " ", time)))
}
filter_radar_signal_within_tracking_data_range <- function(radar_signal_with_datetime, tracking_data_range_by_id) {
  filtered_radar_signal <- radar_signal_with_datetime |>
    dplyr::inner_join(tracking_data_range_by_id, by = dplyr::join_by(bird_id == name)) |>
    dplyr::filter(datetime >= min_datetime & datetime <= max_datetime) |>
    dplyr::transmute(name = bird_id, date, time, latitude = NA_real_, longitude = NA_real_)
}
