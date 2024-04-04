clean_gps <- function(raw_path, bird_id) {
  output_path <- glue::glue("/workdir/tests/data/{bird_id}.csv")
  file_extension <- stringr::str_sub(raw_path, -3)
  clean_method <- list(
    "txt" = xxclean_gps_from_txt,
    "csv" = xxclean_gps_from_csv
  )
  points_with_id <- clean_method[[file_extension]](raw_path, bird_id)
  readr::write_csv(points_with_id, output_path)
}


#' @export
clean_gps_from_txt <- function(raw_path, bird_id, output_path) {
  points_with_id <- xxclean_gps_from_txt(raw_path, bird_id)
  readr::write_csv(points_with_id, output_path)
}

xxclean_gps_from_txt <- function(raw_path, bird_id) {
  extracted_points <- extract_points_from_txt(raw_path)
  add_bird_id(extracted_points, bird_id)
}


#' @export
clean_gps_from_csv <- function(raw_path, bird_id, output_path) {
  points_with_id <- xxclean_gps_from_csv(raw_path, bird_id)
  readr::write_csv(points_with_id, output_path)
}

xxclean_gps_from_csv <- function(raw_path, bird_id) {
  extracted_points <- extract_points_from_csv(raw_path)
  add_bird_id(extracted_points, bird_id)
}

add_bird_id <- function(extracted_points, bird_id) {
  extracted_points |>
    dplyr::mutate(bird_id = bird_id)
}

extract_points_from_txt <- function(raw_path) {
  temporal_file <- "tmp.txt"
  command <- glue::glue("cat {raw_path} | grep --invert-match 'EVENT' > {temporal_file}")
  system(command)
  columns_of_interest <- c("Date", "Time", "Longitude", "Latitude")
  raw <- readr::read_tsv(temporal_file, col_names = columns_of_interest, show_col_types = FALSE) |>
    dplyr::select(dplyr::all_of(columns_of_interest)) |>
    dplyr::mutate(Date = lubridate::dmy(Date))
  return(raw)
}

extract_points_from_csv <- function(raw_path) {
  raw <- readr::read_csv(raw_path, show_col_types = FALSE)
  columns_of_interest <- c("Date", "Time", "Longitude", "Latitude")
  raw |>
    dplyr::select(dplyr::all_of(columns_of_interest))
}
