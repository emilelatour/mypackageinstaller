#' Get the Source of an Installed R Package
#'
#' Determines the source of an installed R package, such as CRAN, Bioconductor, GitHub, or other.
#' This function inspects the package `DESCRIPTION` file to infer the source:
#' - CRAN: Identified via the `Repository` field.
#' - Bioconductor: Identified via the presence of the `biocViews` field.
#' - GitHub: Identified via the `GithubUsername` and `GithubRepo` fields.
#' - Other: Used as a fallback if none of the above metadata is found.
#'
#' @param pkg A character string naming the installed package.
#'
#' @return A character string indicating the source of the package.
#' @examples
#' package_source("ggplot2")     # Typically returns "CRAN"
#' package_source("edgeR")       # Typically returns "Bioconductor"
#' package_source("dplyr")
#' @importFrom utils packageDescription
#' @importFrom stringr str_c
#' @export
package_source <- function(pkg) {
  
  desc <- utils::packageDescription(pkg)
  
  # Check CRAN (Repository field)
  if (!is.null(desc$Repository)) {
    return(as.character(desc$Repository))
  }
  
  # Check Bioconductor (biocViews field is a strong indicator)
  if (!is.null(desc$biocViews)) {
    return("Bioconductor")
  }
  
  # Check GitHub
  if (!is.null(desc$GithubRepo) && !is.null(desc$GithubUsername)) {
    return(stringr::str_c("GitHub repo = ", desc$GithubUsername, "/", desc$GithubRepo))
  }
  
  # Fallback
  return("Other")
}