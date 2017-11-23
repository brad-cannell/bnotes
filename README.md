# bnotes

This package contains random notes about R code and using R that I created for myself. These notes didn't used to be in a package - they were just a folder full of random bits of code. However, the intent behind putting them into a package is to create vignettes with my notes that I can view from within RStudio even while I'm offline.

Because the intent of turning it into a package in the first place was to make it completely viewable offline, I should keep notes/tasks in Evernote.

# Links to vignettes

In addition to creating vignettes that can be viewed inside of RStudio, I also create HTML versions of vignettes that can be viewed online. Links to those files are below.

## Programing and development vignettes

* [Creating packages](https://rawgit.com/brad-cannell/bnotes/master/inst/doc/creating_packages.html)

* [Tidy evaluation: Prgraming with dplyr](https://rawgit.com/brad-cannell/bnotes/master/inst/doc/tidy_evaluation.html)

## Simulation vignettes

## Data wrangling vignettes

## Data analysis vignettes

## Presentation and dissemination vignettes

* [Table of Contents in markdown files](https://rawgit.com/brad-cannell/bnotes/master/inst/doc/table_of_contents.html)

# Installation instructions:

``` r
devtools::install_github("brad-cannell/bnotes", build_vignettes = TRUE)
```
