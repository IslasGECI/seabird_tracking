clean_gps_from_txt <- function(raw_path, bird_id) {
  extracted_points <- extract_points(raw_path)
  extracted_points |> dplyr::mutate(bird_id = bird_id)
}

extract_points <- function(raw_path) {
  columns_of_interest <- c("Date", "Time", "Longitude", "Latitude")
  raw <- readr::read_tsv(raw_path, skip = 15, col_names = columns_of_interest, show_col_types = FALSE) |>
    dplyr::select(dplyr::all_of(columns_of_interest))
  clean_rows <- subset(raw, !stringr::str_detect(Date, "^EVENT"))
  return(clean_rows)
}
