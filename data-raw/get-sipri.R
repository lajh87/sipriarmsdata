

url <- "https://armstrade.sipri.org/armstrade/page/values.php"
req <- httr::GET(url)


country_code <- req |>
  httr::content() |>
  xml2::xml_find_all("//select[@name = 'country_code']//option") |>
  xml2::xml_attr("value")

country_label <- req |>
  httr::content() |>
  xml2::xml_find_all("//select[@name = 'country_code']//option") |>
  xml2::xml_text()

dplyr::tibble(country_code, country_label) |>
  write.csv("data-raw/sipri_country_list.csv", row.names = FALSE)

low_year <- req |>
  httr::content() |>
  xml2::xml_find_all("//select[@name = 'low_year']//option") |>
  xml2::xml_attr("value")

high_year <- req |>
  httr::content() |>
  xml2::xml_find_all("//select[@name = 'high_year']//option") |>
  xml2::xml_attr("value")

summarize <- req |>
  httr::content() |>
  xml2::xml_find_all("//input[@name = 'summarize']") |>
  xml2::xml_attr("value")

filetype <- req |>
  httr::content() |>
  xml2::xml_find_all("//input[@name = 'filetype']") |>
  xml2::xml_attr("value")

import_or_export <- req |>
  httr::content() |>
  xml2::xml_find_all("//input[@name = 'import_or_export']") |>
  xml2::xml_attr("value")


import_raw <- purrr::map(country_code, function(ctry){
  x <- httr::POST(
    url = "https://armstrade.sipri.org/armstrade/html/export_values.php",
    body = list(
      import_or_export = "import",
      summarize = "country",
      low_year = "1950",
      high_year = "2021",
      country_code = ctry,
      filetype = "csv"
    )
  ) |>
    httr::content(as = "raw")

  list(country_code = ctry, raw = x)
})

saveRDS(import_raw, "data-raw/import_raw.RDS")

# Figures are SIPRI Trend Indicator Values (TIVs) expressed in millions.
# Figures may not add up due to the conventions of rounding.
# A '0' indicates that the value of deliveries is less than 0.5m
# For more information, see http://www.sipri.org/databases/armstransfers/sources-and-methods/

import_tiv <- purrr::map_df(import_raw, function(x){
  tryCatch({x$raw |>
  readr::read_csv(skip = 10, col_types = readr::cols()) |>
      dplyr::mutate(Total = as.numeric(Total)) |>
      tidyr::pivot_longer(cols = -1, names_to = "Year", values_to = "TIV", values_drop_na = TRUE) |>
      dplyr::mutate(Import_To = country_label[match(x$country_code, country_code)]) |>
  dplyr::rename(Export_From = ...1) }, error = function(e){})
}) |>
  dplyr::select(4, 1:3)

write.csv(import_tiv, "data/import_tiv.csv", row.names = FALSE)


import_category_raw <- purrr::map(country_code, function(ctry){
  x <- httr::POST(
    url = "https://armstrade.sipri.org/armstrade/html/export_values.php",
    body = list(
      import_or_export = "import",
      summarize = "weapon_category",
      low_year = "1950",
      high_year = "2021",
      country_code = ctry,
      filetype = "csv"
    )
  ) |>
    httr::content(as = "raw")

  list(country_code = ctry, raw = x)
})

import_category <- purrr::map_df(import_category_raw, function(x){
  tryCatch({
    x$raw |>
      readr::read_csv(skip = 10, col_types = readr::cols()) |>
      dplyr::mutate(Total = as.numeric(Total)) |>
      tidyr::pivot_longer(cols = -1, names_to = "Year", values_to = "TIV", values_drop_na=TRUE) |>
      dplyr::mutate(Import_To = country_label[match(x$country_code, country_code)]) |>
      dplyr::rename(Weapon_Category = ...1)
  }, error = function(e){})
})

import_category <- import_category |>
  dplyr::select(4,1:3)

write.csv(import_category, "data/import_category.csv", row.names = FALSE)


export_raw <- purrr::map(country_code, function(ctry){
  x <- httr::POST(
    url = "https://armstrade.sipri.org/armstrade/html/export_values.php",
    body = list(
      import_or_export = "export",
      summarize = "country",
      low_year = "1950",
      high_year = "2021",
      country_code = ctry,
      filetype = "csv"
    )
  ) |>
    httr::content(as = "raw")

  list(country_code = ctry, raw = x)
})

export_tiv <- purrr::map_df(export_raw, function(x){
  tryCatch({x$raw |>
      readr::read_csv(skip = 10, col_types = readr::cols()) |>
      dplyr::mutate(Total = as.numeric(Total)) |>
      tidyr::pivot_longer(cols = -1, names_to = "Year", values_to = "TIV", values_drop_na = TRUE) |>
      dplyr::mutate(Export_From = country_label[match(x$country_code, country_code)]) |>
      dplyr::rename(Import_To = ...1) }, error = function(e){})
}) |>
  dplyr::select(Export_From, Import_To, Year, TIV)

write.csv(export_tiv, "data/export_tiv.csv", row.names = FALSE)

export_category_raw <- purrr::map(country_code, function(ctry){
  x <- httr::POST(
    url = "https://armstrade.sipri.org/armstrade/html/export_values.php",
    body = list(
      import_or_export = "export",
      summarize = "weapon_category",
      low_year = "1950",
      high_year = "2021",
      country_code = ctry,
      filetype = "csv"
    )
  ) |>
    httr::content(as = "raw")

  list(country_code = ctry, raw = x)
})

export_category <- purrr::map_df(export_category_raw, function(x){
  tryCatch({
    x$raw |>
      readr::read_csv(skip = 10, col_types = readr::cols()) |>
      dplyr::mutate(Total = as.numeric(Total)) |>
      tidyr::pivot_longer(cols = -1, names_to = "Year", values_to = "TIV", values_drop_na=TRUE) |>
      dplyr::mutate(Export_From = country_label[match(x$country_code, country_code)]) |>
      dplyr::rename(Weapon_Category = ...1)
  }, error = function(e){})
})

export_category <- export_category |>
  dplyr::select(4,1:3)

write.csv(export_category, "data/export_category.csv", row.names = FALSE)

