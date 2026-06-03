assign_coordinates_to_radar_signal <- function(radar_signal, tracking_data) {
  radar_signal_with_coordinates <- radar_signal |>
    dplyr::left_join(tracking_data, by = dplyr::join_by(bird_id == name, date, time)) |>
    dplyr::rename(name = bird_id)
  radar_signal_with_coordinates |> tidyr::drop_na(latitude, longitude)
}

fill_tracking_data_with_dates_on_radar_signal <- function(radar_signal, tracking_data) {
  tracking_data_with_datetime <- tracking_data |>
    dplyr::mutate(datetime = lubridate::ymd_hms(paste0(date, " ", time)))

  radar_signal_with_datetime <- radar_signal |>
    dplyr::mutate(datetime = lubridate::ymd_hms(paste0(date, " ", time)))

  tracking_data_range_by_id <- tracking_data_with_datetime |>
    dplyr::group_by(name) |>
    dplyr::summarize(min_datetime = min(datetime), max_datetime = max(datetime))

  filtered_radar_signal <- radar_signal_with_datetime |>
    dplyr::inner_join(tracking_data_range_by_id, by = dplyr::join_by(bird_id == name)) |>
    dplyr::filter(datetime >= min_datetime & datetime <= max_datetime) |>
    dplyr::transmute(name = bird_id, date, time, latitude = NA_real_, longitude = NA_real_)

  dplyr::bind_rows(tracking_data, filtered_radar_signal)
}
