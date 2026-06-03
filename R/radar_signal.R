assign_coordinates_to_radar_signal <- function(radar_signal, tracking_data) {
  radar_signal_with_coordinates <- tracking_data |>
    dplyr::left_join(radar_signal, by = dplyr::join_by(name == bird_id, date, time))
  radar_signal_with_coordinates
}
