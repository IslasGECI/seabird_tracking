extract_points <- function(raw_path) {
  raw <- readr::read_tsv(raw_path, skip = 15, col_names = c("Date", "Time", "Longitude", "Latitude")) |>
    dplyr::select(c("Date", "Time", "Longitude", "Latitude"))
  clean_rows <- subset(raw, !stringr::str_detect(Date, "^EVENT"))
  return(clean_rows)
}
