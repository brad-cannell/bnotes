## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE----------------------------------------------------------
#  install.packages(c("devtools", "roxygen2", "testthat", "knitr"))

## ----eval=FALSE----------------------------------------------------------
#  devtools::install_github("hadley/devtools")
#  library(devtools)
#  has_devel()

## ----eval=FALSE----------------------------------------------------------
#  Package: sandbox
#  Type: Package
#  Title: Test Stuff Out
#  Version: 0.1
#  Date: 2016-03-28
#  Authors@R: person("Brad", "Cannell", email = "brad.cannell@gmail.com",
#    role = c("aut", "cre"))
#  Maintainer: Brad Cannell <brad.cannell@gmail.com>
#  URL: https://github.com/mbcann01/sandbox
#  BugReports: https://github.com/mbcann01/sandbox/issues
#  Description: This is just a sandbox for me to test out package stuff and
#    Github.
#  License: MIT + file LICENSE
#  LazyData: TRUE
#  RoxygenNote: 5.0.1
#  VignetteBuilder: knitr
#  Depends: R (>= 3.2.3)
#  Suggests:
#      knitr,
#      rmarkdown
#  Imports:
#      dplyr

## ----eval = FALSE--------------------------------------------------------
#  #' @title Compact Table of Summary Statistics
#  #'
#  #' @description  Based on Stata's "tabstat" command. "tabstat displays summary
#  #'  statistics for a series of numeric variables in one table.  It allows you
#  #'  to specify the list of statistics to be displayed.  Statistics can be
#  #'  calculated (conditioned on) another variable.  tabstat allows substantial
#  #'  flexibility in terms of the statistics presented and the format of the
#  #'  table" (Stata, 2016).
#  #'
#  #' @param x A continuous variable.
#  #' @param digits Rounds the values returned to the specified number of decimal
#  #'  places (default 3).
#  #' @param stats Return specified statistics. Options include:
#  #'  \describe{
#  #'    \item{n}{Count of nonmissing values of x}
#  #'    \item{nmiss}{Count of missing values of x}
#  #'    \item{ci}{95 percent confidence interval for the mean of x}
#  #'    \item{sum}{Sum of x}
#  #'    \item{max}{Maximum value of x}
#  #'    \item{min}{Minimum value of x}
#  #'    \item{range}{(Maximum value of x) - (minimum value of x)}
#  #'    \item{sd}{Standard deviation of x}
#  #'    \item{var}{Variance of x}
#  #'    \item{cv}{Coefficient of variation (sd / mean) of x}
#  #'    \item{sem}{Standard error of the mean of x}
#  #'    \item{skew}{Skewness of x}
#  #'    \item{kurt}{Kurtosis of x}
#  #'    \item{p1}{1st percentile of x}
#  #'    \item{p5}{5th percentile of x}
#  #'    \item{p10}{10th percentile of x}
#  #'    \item{p25}{25th percentile of x}
#  #'    \item{p50}{Median value of x}
#  #'    \item{median}{Median value of x}
#  #'    \item{p75}{75th percentile of x}
#  #'    \item{p90}{90th percentile of x}
#  #'    \item{p95}{95th percentile of x}
#  #'    \item{p99}{99th percentile of x}
#  #'    \item{iqr}{Interquartile range (p75 - p25)}
#  #'    \item{q}{Equivalent to specifying p25 p50 p75}
#  #'  }
#  #'
#  #' @return A data frame. By default, the data frame contains the variable name
#  #'  and mean.
#  #' @export
#  #'
#  #' @references Stata 14 help for tabstat
#  #'  \url{http://www.stata.com/help.cgi?tabstat}
#  #'
#  #' @examples
#  #' data(mtcars)
#  #'
#  #' # Single univariate analysis with Defaults
#  #' tabstat(mtcars$mpg)
#  #'
#  #' # Single univariate analysis with all stats
#  #' tabstat(mtcars$mpg, stats = c("n", "nmiss", "ci", "sum", "max", "min",
#  #' "range", "sd", "var", "cv", "sem", "skew", "kurt", "p1", "p5", "p10",
#  #' "p25", "p50", "median", "p75", "p90", "p95", "p99", "iqr", "q"))

## ----eval = FALSE--------------------------------------------------------
#  URL: https://github.com/mbcann01/dataclean
#  BugReports: https://github.com/mbcann01/dataclean/issues

## ----eval = FALSE--------------------------------------------------------
#  library(devtools)
#  devtools::install_github("mbcann01/detectPilotTest")
#  library(detectPilotTest)
#  browseVignettes("detectPilotTest")

