assign_coordinates_to_radar_signal <- function(radar_signal, tracking_data) {
  radar_signal_with_coordinates <- radar_signal |>
    dplyr::left_join(tracking_data, by = dplyr::join_by(bird_id == name, date, time)) |>
    dplyr::rename(name = bird_id)
  radar_signal_with_coordinates |> tidyr::drop_na(latitude, longitude)
}

fill_tracking_data_with_dates_on_radar_signal <- function(radar_signal, tracking_data) {
  dplyr::bind_rows(tracking_data, radar_signal |> dplyr::rename(name = bird_id))
}
