library(rworldmap)
worldmap <- getMap(resolution = "low")
worldmap@data |>
  dplyr::select(ISO_A2, ISO_A3, NAME) |>
  write.csv("data-raw/rworldmap_countries.csv", row.names = FALSE)



