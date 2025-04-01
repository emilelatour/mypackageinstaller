
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


#### Get the list of installed packages  --------------------------------

(list_of_installed_pkgs <- get_installed_packages())

(as_of_date <- paste0(Sys.Date()))

#### Save to csv --------------------------------

(file_path <- here::here("my-installed-packages",
                         glue::glue("my-package-list_{as_of_date}.csv")))

readr::write_csv(x = list_of_installed_pkgs$installed,
                 file = file_path)

