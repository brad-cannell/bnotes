## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
library(tidyverse)
data("starwars")

## ------------------------------------------------------------------------
# Computing the value of the expression:
toupper(letters[1:5])

## ------------------------------------------------------------------------
# Capturing the expression:
quote(toupper(letters[1:5]))

## ------------------------------------------------------------------------
# What does quo() return?
quo(species) # Where species is a variable in the Starwars tibble

## ------------------------------------------------------------------------
# Basic usage of quo() in function
freq_table <- function(df, x, ...) {
  df %>%                             # No quoting and unquoting necessary for the tibble
    group_by(!!x) %>%                # Don't forget to unquote (!!) where you want the quoture evaluated
    summarise(N = n()) %>%           # Calculate freq
    top_n(3, N)                      # Return top 3 results
}

freq_table(df = starwars, x = quo(species))

## ------------------------------------------------------------------------
# Basic usage of enquo() in function
freq_table <- function(df, x, ...) {
  x <- enquo(x)                      # Capturing function argument and turning it into a quoture
  df %>%                             
    group_by(!!x) %>%                
    summarise(N = n()) %>%           
    top_n(3, N)                      
}

freq_table(df = starwars, x = species) # Notice we no longer need to wrop species with quo()

## ------------------------------------------------------------------------
# What does quos() return?
quos(species, name) # Where species and name are variables in the Starwars tibble

## ------------------------------------------------------------------------
my_quos <- quos(species, name)
for(i in seq_along(my_quos)) {
  print(my_quos[[i]])
}

## ------------------------------------------------------------------------
# Basic use of quos() in a for loop
my_quos <- quos(species, name)
for(i in seq_along(my_quos)) {
  summarise(starwars, n_miss = sum(is.na(!!my_quos[[i]]))) %>% print # Can use !! or !!! in this case
}

## ------------------------------------------------------------------------
# Basic usage of quos() in function
freq_table <- function(df, ...) {    # Notice we dropped the "x" argument
  x <- quos(...)                     # Capturing function argument and turning it into a quoture list
  df %>%                             
    group_by(!!!x) %>%               # Must use unquote-splice (!!!) in this case
    summarise(N = n()) %>%
    ungroup() %>% 
    slice(1:5)                      
}

freq_table(df = starwars, species, hair_color)

## ------------------------------------------------------------------------
# What does quo_name return?
quo_name("height") # Input must be a string or a quoture

## ------------------------------------------------------------------------
# What does quo_name return?
height <- quo(height)
quo_name(height) # Input must be a string or a quoture

## ------------------------------------------------------------------------
# Basic usage of quos() in function
continuous_table <- function(df, x) {
  x2 <- enquo(x)                             # Must enquo first
  mean_name <- paste0("mean_", quo_name(x2))
  sum_name  <- paste0("sum_", quo_name(x2))
  
  df %>% 
    summarise(
      !!mean_name := mean(!!x2, na.rm = TRUE), # Must use !! and := to set the variable names
      !!sum_name  := sum(!!x2, na.rm = TRUE)
    )
}

continuous_table(starwars, height)

## ------------------------------------------------------------------------
starwars <- mutate(starwars, human = if_else(species == "Human", "Yes", "No", NA_character_))

## ------------------------------------------------------------------------
vars = 3        # Number of vars
rows = vars + 1 # Additional row for group sample size
table <- tibble(
  Variable = vector(mode = "character", length = rows),
  Human = vector(mode = "character", length = rows),
  `Not Human` = vector(mode = "character", length = rows)
)

# N for Human
table[1, 2] <- paste0(
  "(N = ",
  filter(starwars, human == "Yes") %>% nrow() %>% format(big.mark = ","),
  ")"
)

# N for Not Human
table[1, 3] <- paste0(
  "(N = ",
  filter(starwars, human == "No") %>% nrow() %>% format(big.mark = ","),
  ")"
)

## ------------------------------------------------------------------------
vars <- c(quo(height), quo(mass), quo(birth_year)) # Create vector of quotures for variables of interest

for(i in seq_along(vars)) {
  table[i + 1, ] <- starwars %>%                             # Chunk of table to receive loop output
    filter(!is.na(human)) %>% 
    group_by(human) %>% 
    summarise(Mean = mean(!!vars[[i]], na.rm = TRUE)) %>%    # Use !! with vars[[i]]
    mutate(Mean = round(Mean, 1) %>% format(nsmall = 1)) %>% 
    spread(human, Mean) %>% 
    mutate(Variable = quo_name(vars[[i]])) %>%               # Use quo_name to get variable name for first column
    select(Variable, Yes, No)
}

## ------------------------------------------------------------------------
vars <- quos(height, mass, birth_year)

for(i in seq_along(vars)) {
  table[i + 1, ] <- starwars %>%                             # Chunk of table to receive loop output
    filter(!is.na(human)) %>% 
    group_by(human) %>% 
    summarise(Mean = mean(!!vars[[i]], na.rm = TRUE)) %>%    # Use !! with vars[[i]]
    mutate(Mean = round(Mean, 1) %>% format(nsmall = 1)) %>% 
    spread(human, Mean) %>% 
    mutate(Variable = quo_name(vars[[i]])) %>%               # Use quo_name to get variable name for first column
    select(Variable, Yes, No)
}

## ------------------------------------------------------------------------
starwars <- mutate(starwars, human = if_else(species == "Human", "Yes", "No", NA_character_))

## ------------------------------------------------------------------------
vars = 3        # Number of vars
rows = vars + 1 # Additional row for group sample size
table <- tibble(
  Variable = vector(mode = "character", length = rows),
  Human = vector(mode = "character", length = rows),
  `Not Human` = vector(mode = "character", length = rows)
)

# N for Human
table[1, 2] <- paste0(
  "(N = ",
  filter(starwars, human == "Yes") %>% nrow() %>% format(big.mark = ","),
  ")"
)

# N for Not Human
table[1, 3] <- paste0(
  "(N = ",
  filter(starwars, human == "No") %>% nrow() %>% format(big.mark = ","),
  ")"
)

## ------------------------------------------------------------------------
my_stats <- function(...) {
  vars <- quos(...)                                           # Creates a list of quotures from variable names
  temp <- get("table")                                        # Grabs a copy of the table shell from the environment
  temp <- temp[0, ]                                           # Only keep the column headers
  
  for(i in seq_along(vars)) {                                 # Loop over all variables in ...
    out <- quo(!!vars[[i]])                                   # Not necessary, but makes more readable.
    name <- quo_name(out)                                     # Turns variable name into string for mutate below.
    row <- starwars %>%                                       # Creates a single row of stats for the table.
      filter(!is.na(human)) %>% 
      group_by(human) %>% 
      summarise(Mean = mean(!!out, na.rm = TRUE)) %>%         # Still need !!
      mutate(Mean = round(Mean, 1) %>% format(nsmall = 1)) %>% 
      spread(human, Mean) %>% 
      mutate(Variable = name) %>%
      select(Variable, Yes, No)
    temp <- rbind(temp, row)
  }
  temp
}

## ------------------------------------------------------------------------
table[2:4, ] <- my_stats(height, mass, birth_year)            # Notice that we no longer need to us quo

## ------------------------------------------------------------------------
vars <- quos(gender, species)

map_df(vars, function(x){
  starwars %>%
    group_by(!! x) %>%
    summarise(mean(height, na.rm = TRUE))
})

## ----error=TRUE----------------------------------------------------------
# vars <- quos(gender, species)
# 
# map_df(vars, ~ {
#   starwars %>%
#     group_by(!! .) %>%
#     summarise(mean(height, na.rm = TRUE))
# })

## ------------------------------------------------------------------------
vars <- quos(gender, species)

map_df(vars, ~ {
  starwars %>%
    group_by(!! .x) %>%
    summarise(mean(height, na.rm = TRUE))
})

## ------------------------------------------------------------------------
vars <- quos(gender, species)

map(vars, function(x) {
  x
})

## ------------------------------------------------------------------------
map(vars, ~ {
  rlang::UQ(.)
})

## ------------------------------------------------------------------------
map(vars, ~ {
  rlang::UQ(.x)
})

## ----include=FALSE-------------------------------------------------------
# Load packages and data again - if necessary
library(tidyverse)
data("starwars")

## ----error=TRUE----------------------------------------------------------
example <- function(df, var, ...) {
  x <- enquo(var)
  
  print(!!x) # This doesn't work - need to associate the quoture variable with its data frame
}
starwars %>% example(hair_color)

## ------------------------------------------------------------------------
example <- function(df, var, ...) {
  x <- enquo(var)
  
  df %>% select(!!x) %>% print()
}
starwars %>% example(hair_color)

## ----error=TRUE----------------------------------------------------------
example <- function(df, var) {
  x <- enquo(var)
  
  df %>% 
    mutate(hair_color = if_else(!!x == "yellow", "blond", !!x))
}
starwars %>% example(hair_color)

## ------------------------------------------------------------------------
example <- function(df, var) {
  x <- enquo(var)
  
  df %>% 
    mutate(hair_color = if_else(rlang::UQ(x) == "yellow", "blond", rlang::UQ(x)))
}
starwars %>% example(hair_color)

## ----error=TRUE----------------------------------------------------------
example <- function(df, var) {
  x <- enquo(var)
  
  df %>% 
    mutate(!!x = if_else(rlang::UQ(x) == "yellow", "blond", rlang::UQ(x)))
}
starwars %>% example(hair_color)

## ----error=TRUE----------------------------------------------------------
example <- function(df, var) {
  x <- enquo(var)
  
  df %>% 
    mutate(!!x := if_else(rlang::UQ(x) == "yellow", "blond", rlang::UQ(x)))
}
starwars %>% example(hair_color)

## ------------------------------------------------------------------------
example <- function(df, var) {
  x <- enquo(var)
  
  df %>% 
    mutate(!!quo_name(x) := if_else(rlang::UQ(x) == "yellow", "blond", rlang::UQ(x)))
}
starwars %>% example(hair_color)

## ------------------------------------------------------------------------
example <- function(df, var) {
  x <- enquo(var)                              # Make sure to use enquo here
  
  df %>% 
    summarise(
      Mean = mean(!!x, na.rm = TRUE)
    ) %>% 
    mutate(Characteristic = !!quo_name(x)) %>% # Make sure to use !!quo_name()
    select(Characteristic, Mean)
}

starwars %>% example(height)

## ------------------------------------------------------------------------
my_col <- names(starwars[2]) # Have a variable name as a quoted string
my_col <- "mass"
starwars %>% select(!!my_col) # Now this works

## ------------------------------------------------------------------------
starwars$height_squared <- starwars$height**2

## ------------------------------------------------------------------------
example <- function(df, var) {
  
  x <- enquo(var)  # First, turn var without the suffix into a quoture - must be first
  squared <- paste(quo_name(x), "squared", sep = "_") # Must use quo_name()
  
  df %>% 
    summarise(
      Mean = mean(!!squared, na.rm = TRUE)
    )
}

starwars %>% example(height)

## ------------------------------------------------------------------------
example <- function(df, var) {
  
  x <- enquo(var)  # First, turn var without the suffix into a quoture - must be first
  squared <- paste(quo_name(x), "squared", sep = "_") # Must use quo_name()
  squared <- rlang::sym(squared) # Wrap with sym()

  df %>%
    summarise(
      Mean = mean(!!squared, na.rm = TRUE)
    )
}

starwars %>% example(height)

## ------------------------------------------------------------------------
example <- function(df, var) {
  
  x <- enquo(var)  # First, turn var without the suffix into a quoture - must be first
  squared <- paste(quo_name(x), "squared", sep = "_") # Must use quo_name()
  squared <- as.name(squared) # Wrap with as.name()

  df %>%
    summarise(
      Mean = mean(!!squared, na.rm = TRUE)
    )
}

starwars %>% example(height)

## ------------------------------------------------------------------------
example <- function(df, var) {
  
  x <- enquo(var)  # First, turn var without the suffix into a quoture - must be first
  squared <- paste(quo_name(x), "squared", sep = "_") # Must use quo_name()
  squared <- rlang::parse_quosure(squared) # Wrap with parse_quosure

  df %>%
    summarise(
      Mean = mean(!!squared, na.rm = TRUE)
    )
}

starwars %>% example(height)

## ----echo=FALSE----------------------------------------------------------
sessionInfo()

