
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aion

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/aion)](https://CRAN.R-project.org/package=aion)
<!-- badges: end -->

Temporal Fusion Transformer for keras in R

## Installation

You can install the development version of aion from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("krzjoa/keras.tft")
```

## Usage

``` r
# Dataset
library(m5)

# Neural Networks
library(aion)
library(keras)

# Data wrangling
library(recipes, warn.conflicts=FALSE)
#> Ładowanie wymaganego pakietu: dplyr
#> 
#> Dołączanie pakietu: 'dplyr'
#> Następujące obiekty zostały zakryte z 'package:stats':
#> 
#>     filter, lag
#> Następujące obiekty zostały zakryte z 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(dplyr, warn.conflicts=FALSE)
library(data.table, warn.conflicts=FALSE)

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

setDT(train)
setDT(test)

# ==========================================================================
#                          CREATING GENERATORS
# ==========================================================================

c(train_generator, train_steps) %<-%
    ts_generator(
        data = train,
        key = KEY,
        index = INDEX,
        lookback = LOOKBACK,
        horizon = HORIZON,
        stride = STRIDE,
        target=TARGET,
        static=STATIC,
        categorical=CATEGORICAL,
        numeric=NUMERIC,
        batch_size=BATCH_SIZE    
  )

batch <- train_generator()
print(names(batch))
#> [1] "y_past"       "X_past_num"   "X_past_cat"   "y_fut"        "X_fut_num"   
#> [6] "X_fut_cat"    "X_static_cat"

test_generator <-
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

# <https://github.com/LongxingTan/Time-series-prediction/blob/master/tfts/layers/nbeats_layer.py>
