#' Get and Summarize Installed R Packages
#'
#' Retrieves a list of installed R packages (excluding base packages),
#' identifies the source (e.g., CRAN, GitHub, Bioconductor), and returns
#' summary information including a count and breakdown by source.
#'
#' @return A list containing:
#' \describe{
#'   \item{n_installed}{The number of non-base installed packages.}
#'   \item{source_summary}{A summary table showing counts by source.}
#'   \item{other_source}{A data frame of packages with unknown sources.}
#'   \item{installed}{A full tibble of installed packages with metadata and source.}
#' }
#' @examples
#' pkgs <- get_installed_packages()
#' pkgs$source_summary
#' @seealso [utils::installed.packages()], [package_source()]
#' @importFrom utils installed.packages
#' @importFrom tibble as_tibble
#' @importFrom dplyr filter select mutate
#' @importFrom janitor clean_names tabyl
#' @importFrom purrr map_chr
#' @export
get_installed_packages <- function() {

  installed <- utils::installed.packages(fields = "URL") %>%
    tibble::as_tibble() %>%
    dplyr::filter(Priority != "base" | is.na(Priority)) %>%
    dplyr::select(-c(Enhances:MD5sum, LinkingTo:Suggests)) %>%
    droplevels() %>%
    janitor::clean_names()

  n_installed <- nrow(installed)

  installed <- installed %>%
    dplyr::mutate(source = purrr::map_chr(.x = package,
                                          .f = ~ package_source(pkg = .x)))

  source_summary <- installed %>%
    janitor::tabyl(source)

  other_source <- installed %>%
    dplyr::filter(source == "Other") %>%
    dplyr::select(package, version)

  list_of_installed_pkgs <- list(
    n_installed = n_installed,
    source_summary = source_summary,
    other_source = other_source,
    installed = installed
  )

  return(list_of_installed_pkgs)
}
