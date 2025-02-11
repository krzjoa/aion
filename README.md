
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aeon

<img src='man/figures/aion-small.png' align="right" height="250" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/aeon)](https://CRAN.R-project.org/package=aeon)
[![Buy hex
stciker](https://img.shields.io/badge/buy%20hex-aion-green?style=flat&logo=redbubble)](https://www.redbubble.com/i/sticker/aion-R-package-hex-by-krzjoa/126321293.EJUG5)

<!-- badges: end -->

> Time Series models for keras in R

## Installation

You can install the development version of aion from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("krzjoa/aion")
```

## Key features

-   Temporal Fusion Transformer model
-   additional layers: Temporal Convolutional Network block & Legendre
    Memory Unit
-   `make_array` and `ts_generator` functions to quickly prepare
    input/output for `{keras}` time series models
-   new loss functions: `loss_quantile`, `loss_tweedie` and
    `loss_negative_log_likelihood`

## Usage

``` r
# Dataset
library(m5)

# Neural Networks
library(aion)
library(keras)

# Data wrangling
library(dplyr, warn.conflicts=FALSE)
library(data.table, warn.conflicts=FALSE)
library(recipes, warn.conflicts=FALSE)

# ==========================================================================
#                          PREPARING THE DATA
# ==========================================================================

train <- tiny_m5[date < '2016-01-01']
test  <- tiny_m5[date >= '2016-01-01']

m5_recipe <-
  recipe(value ~ ., data=train) %>%
  step_mutate(item_id_idx=item_id, store_id_idx=store_id) %>%
  step_integer(item_id_idx, store_id_idx,
               wday, month,
               event_name_1, event_type_1,
               event_name_2, event_type_2,
               zero_based=TRUE) %>%
  step_naomit(all_predictors()) %>%
  prep()

train <- bake(m5_recipe, train)
test  <- bake(m5_recipe, test)

TARGET      <- 'value'
STATIC      <- c('item_id_idx', 'store_id_idx')
CATEGORICAL <- c('event_name_1', 'event_type_1', STATIC)
NUMERIC     <- c('sell_price', 'sell_price')
KEY         <- c('item_id', 'store_id')
INDEX       <- 'date'
LOOKBACK    <- 28
HORIZON     <- 14
STRIDE      <- LOOKBACK
BATCH_SIZE  <- 32

# ==========================================================================
#                          CREATING GENERATORS
# ==========================================================================

c(train_generator, train_steps) %<-%
    ts_generator(
        data        = train,
        key         = KEY,
        index       = INDEX,
        lookback    = LOOKBACK,
        horizon     = HORIZON,
        stride      = STRIDE,
        target      = TARGET,
        static      = STATIC,
        categorical = CATEGORICAL,
        numeric     = NUMERIC,
        batch_size  = BATCH_SIZE    
  )

c(test_generator, test_steps)  %<-%
    ts_generator(
        data = test,
        key = KEY,
        index = INDEX,
        lookback = LOOKBACK,
        horizon = HORIZON,
        stride = STRIDE,
        target=TARGET,
        static=STATIC,
        categorical=CATEGORICAL,
        numeric=NUMERIC
    )
```

## Package name
The package was initially named aion. However, I was waiting so long with publishing it and [somebody](https://github.com/tesselle/aion) has beaten me to it. 
