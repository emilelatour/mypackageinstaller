
#### Packages -----------------------------

pacman::p_load(
  tidyverse,     # packages ggplot2, dplyr, tidyr, readr, purrr, tibble,
  # stringr, and forcats
  broom,         # functions tidy(), glance(), augment()
  flextable,     # Easily create tables for reporting and publications.
  fs,            # Cross-platform interface to file system operations
  glue,          # Glue strings to data in R
  gt,            # Easily Create Presentation-Ready Display Tables
  here,          # Constructs paths to your project's files
  janitor,       # for working with dirty data
  khroma,        # Colour Schemes for Scientific Data Visualization
  lubridate,     # Functions to work with date-times and time-spans
  mice,          # Multiple imputation using Fully Conditional Specification
  naniar,        # structures, summaries, and visualisations for missing data
  patchwork,     # combine separate ggplots into the same graphic
  readxl,        # read in excel files
  rstatix,       # Pipe-Friendly Framework for Basic Statistical Tests
  scales,        # Scale functions for visualization
  skimr,         # Compact and Flexible Summaries of Data
  smplot2,       # Creating and annotating a composite plot in ggplot2
  install = FALSE
)


#### Re-install packages --------------------------------

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = BiocManager::version())

(file_path <- here::here("my-installed-packages",
                         "my-package-list_2025-04-01.csv")
)
previous <- readr::read_csv(file = file_path)

install_if_missing = TRUE

#### Get current installed packages --------------------------------

current <- installed.packages() %>%
  tibble::as_tibble() %>%
  janitor::clean_names()

#### what needs to be installed --------------------------------

need_to_install <- previous %>%
  dplyr::filter(!package %in% current$package)

n_installed <- nrow(current)
n_previous <- nrow(need_to_install)


#### Install Bioconductor and CRAN packages --------------------------------

if (install_if_missing) {

  BiocManager::install(need_to_install$package)
}


#### Install github --------------------------------

current <- installed.packages() %>%
  tibble::as_tibble() %>%
  janitor::clean_names()

need_to_install <- previous %>%
  dplyr::filter(!package %in% current$package)

#if (install_if_missing) {



github_repos1 <- previous %>%
  dplyr::filter(!package %in% current$package) %>%
  dplyr::select(package, source) %>%
  dplyr::mutate(repo = stringr::str_remove(source, "GitHub repo = ")) %>%
  dplyr::filter(repo != "Other") %>%
  dplyr::pull(repo) %>%
  na.omit()

github_repos2 <- previous %>%
  dplyr::filter(!package %in% current$package) %>%
  dplyr::select(package, url) %>%
  dplyr::mutate(repo = stringr::str_remove(url, "http[s]?://github.com/")) %>%
  dplyr::filter(repo != "Other") %>%
  dplyr::pull(repo) %>%
  na.omit()

github_repos <- unique(c(github_repos1, github_repos2))
github_repos <- github_repos[!stringr::str_starts(github_repos,"http")]

# try to use repo to install github
# lapply(github_repos, function(k) try(remotes::install_github(k)))
purrr::walk(.x = github_repos,
            .f = ~ try(remotes::install_github(.x)))

#}

#### Others still not installed --------------------------------


current <- installed.packages() %>%
  tibble::as_tibble() %>%
  janitor::clean_names()

need_to_install <- previous %>%
  dplyr::filter(!package %in% current$package)

need_to_install
# # A tibble: 4 × 10
#   package    lib_path                               version priority depends imports needs_compilation built url   source
#   <chr>      <chr>                                  <chr>   <chr>    <chr>   <chr>   <chr>             <chr> <chr> <chr>
# 1 hrbraddins /Library/Frameworks/R.framework/Versi… 0.4.0   NA       R (>= … "rstud… no                4.4.0 "htt… GitHu…
# 2 rtweet     /Library/Frameworks/R.framework/Versi… 2.0.0   NA       R (>= … "bit64… no                4.4.0 "htt… CRAN
# 3 twitteR    /Library/Frameworks/R.framework/Versi… 1.1.9   NA       R (>= … "metho… no                4.4.0 "htt… CRAN
# 4 visR       /Library/Frameworks/R.framework/Versi… 0.4.1   NA       R (>= … "broom… no                4.4.0 "htt… CRAN
