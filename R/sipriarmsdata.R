#' Exports by Destination
#'
#' Information on all transfers of major conventional weapons from 1950 to
#'   the most recent full calendar year
#'
#' @format A data frame with 30628 rows and 4 variables:
#' \describe{
#'   \item{Export_From}{The exporting country}
#'   \item{Import_To}{The importing country}
#'   \item{Year}{Year}
#'   \item{TIV}{Trade Indicator Values, in US Dollars}
#'   ...
#' }
#' @source \url{https://www.sipri.org/databases/armstransfers}
"sipritiv"


#' Exports by Weapons Category
#'
#' Information on all transfers of major conventional weapons from 1950 to
#'   the most recent full calendar year
#'
#' @format A data frame with 12115 rows and 4 variables:
#' \describe{
#'   \item{Export_From}{The exporting country}
#'   \item{Weapon_Category}{The Category of Weapon}
#'   \item{Year}{Year}
#'   \item{TIV}{Trade Indicator Values, in US Dollars}
#'   ...
#' }
#' @source \url{https://www.sipri.org/databases/armstransfers}
"sipri_cat"
