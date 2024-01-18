extract_points <- function(raw_path) {
  readr::read_tsv(raw_path, skip = 15, col_names = c("Date", "Time", "Longitude", "Latitude")) |>
    dplyr::select(c("Date", "Time", "Longitude", "Latitude"))
}
