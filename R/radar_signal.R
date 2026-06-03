assign_coordinates_to_radar_signal <- function(radar_signal, tracking_data) {
  radar_signal_with_coordinates <- radar_signal |>
    dplyr::left_join(tracking_data, by = dplyr::join_by(bird_id == name, date, time)) |>
    dplyr::rename(name = bird_id)
  radar_signal_with_coordinates
}
