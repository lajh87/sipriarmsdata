sipritiv <- readr::read_csv("data/export_tiv.csv")
sipri_cat <- readr::read_csv("data/export_category.csv")
usethis::use_data(sipritiv, overwrite = TRUE)
usethis::use_data(sipri_cat, overwrite = TRUE)
