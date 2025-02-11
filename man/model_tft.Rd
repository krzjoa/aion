% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/model-tft.R
\name{model_tft}
\alias{model_tft}
\title{Temporal Fusion Transformer model}
\usage{
model_tft(...)
}
\arguments{
\item{lookback}{Number of timesteps from the past}

\item{horizon}{Forecast length (number of timesteps)}

\item{past_numeric_size}{Number of numeric features from the past}

\item{past_categorical_size}{Number of categorical features from the past}

\item{future_numeric_size}{Number of numeric features from the future}

\item{output_size}{Number of the models output. For simple point estimate set \code{1}.}
}
\description{
Temporal Fusion Transformer model
}
\examples{
library(keras)
library(aion)

tft <- model_tft(
   lookback                = 28,
   horizon                 = 14,
   past_numeric_size       = 5,
   past_categorical_size   = 2,
   future_numeric_size     = 4,
   future_categorical_size = 2,
   vocab_static_size       = c(5, 5),
   vocab_dynamic_size      = c(4, 4),
   hidden_dim              = 12,
   state_size              = 7,
   num_heads                 = 10,
   dropout_rate            = 0.1,
   output_size             = 3
   #quantiles               = 0.5
)

x_static_cat <- array(sample(5, 32 * 2, replace=TRUE), c(32, 2)) - 1
x_static_num <- array(runif(32 * 1), c(32, 1))

x_past_num <- array(runif(32 * 28 * 2), c(32, 28, 2))
x_past_cat <- array(sample(4, 32 * 28 * 2, replace=TRUE), c(32, 28, 5))

x_fut_num <- array(runif(32 * 14 * 5), c(32, 28, 1))
x_fut_cat <- array(sample(4, 32 * 14 * 2, replace=TRUE), c(32, 28, 5))

tft(x_past_num, x_past_cat, x_fut_num, x_fut_cat, x_static_num, x_static_cat)

}
\references{
\enumerate{
\item \href{https://arxiv.org/abs/1912.09363}{Paper}
\item \href{https://github.com/google-research/google-research/blob/master/tft/libs/tft_model.py}{Original TFT implementation in TensorFlow}
\item \href{https://github.com/PlaytikaResearch/tft-torch/blob/main/tft_torch/tft.py}{A very clear implementation in PyTorch}
}
}
\seealso{
TFT components:

\code{\link[=layer_glu]{layer_glu()}}, \code{\link[=layer_grn]{layer_grn()}}, \code{\link[=layer_multi_embedding]{layer_multi_embedding()}}, \code{\link[=layer_multi_dense]{layer_multi_dense()}},
\code{\link[=layer_scaled_dot_attention]{layer_scaled_dot_attention()}}, \code{\link[=layer_interpretable_mh_attention]{layer_interpretable_mh_attention()}}, \code{\link[=layer_temporal_fusion_decoder]{layer_temporal_fusion_decoder()}}
}
