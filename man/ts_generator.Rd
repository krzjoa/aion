% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ts-generator.R
\name{ts_generator}
\alias{ts_generator}
\title{Create a generator for time series data}
\usage{
ts_generator(
  data,
  key,
  index,
  lookback,
  horizon,
  stride = 1,
  target,
  numeric = NULL,
  categorical = NULL,
  static = NULL,
  past = NULL,
  future = NULL,
  shuffle = TRUE,
  sample_frac = 1,
  y_past_sep = FALSE,
  batch_size = 1,
  ...
)
}
\arguments{
\item{data}{A \verb{[data.table::data.table()]} instance}

\item{lookback}{The length of the context from the past}

\item{horizon}{The forecast length}

\item{stride}{Stride of the moving window}

\item{target}{Target variable(s)}

\item{numeric}{Numeric variables}

\item{categorical}{Categorical variables}

\item{static}{Static variables}

\item{shuffle}{Shuffle samples. Set \code{FALSE} for the test dataset.}

\item{y_past_sep}{Return past values of the target variable as a separate array.
Typically, it returned as a first feature of the \code{x_past_num} array. However,
for some models (such as \strong{NBEATS}) it may be easier for further processing
to keep these values as a separate array.}

\item{batch_size}{Batch size}
}
\description{
The advantage of the generator over the explicit arrays creation by \code{make_arrays}
at the beginning is the lower RAM space volume needed for this kind of operation.
When full arrays are created, we have to allocate space for all the examples
selected from the passed \code{data.frame}. If we use \code{ts_generator} instead,
the following examples are deliver as the batch sub-arrays and created on fly.
It means that we don't have to store all the examples in RAM at the same time.
}
\examples{
library(m5)
library(recipes, warn.conflicts=FALSE)
library(zeallot)
library(dplyr, warn.conflicts=FALSE)
library(data.table, warn.conflicts=FALSE)

# ==========================================================================
#                          PREPARING THE DATA
# ==========================================================================
train <- tiny_m5[date < '2016-01-01']
test  <- tiny_m5[date >= '2016-01-01']

m5_recipe <-
   recipe(value ~ ., data=train) \%>\%
   step_mutate(item_id_idx=item_id, store_id_idx=store_id) \%>\%
   step_integer(item_id_idx, store_id_idx,
                wday, month,
                event_name_1, event_type_1,
                event_name_2, event_type_2,
                zero_based=TRUE) \%>\%
   step_naomit(all_predictors()) \%>\%
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
#                          CREATING GENERATOR
# ==========================================================================
c(train_generator, train_steps) \%<-\%
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
print(names(batch[[1]]))
}
