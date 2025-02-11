% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/layer-temporal-fusion-decoder.R
\name{layer_temporal_fusion_decoder}
\alias{layer_temporal_fusion_decoder}
\title{Temporal Fusion Decoder layer}
\usage{
layer_temporal_fusion_decoder(
  object,
  hidden_units,
  state_size,
  dropout_rate = 0,
  use_context,
  num_heads,
  ...
)
}
\description{
One of blocks, the TFT model consists of. During the call, it accepts two
parameters:
\itemize{
\item output of the LSTM
\item static context
The LSTM output is enriched with the static context features and additionally
processed ath the end.
}
}
\examples{
lookback   <- 28
horizon    <- 14
all_steps  <- lookback + horizon
state_size <- 5

lstm_output <- layer_input(c(all_steps, state_size))
context     <- layer_input(state_size)

# No attentiion scores returned
tdf <- layer_temporal_fusion_decoder(
   hidden_units = 30,
   state_size = state_size,
   use_context = TRUE,
   num_heads = 10
)(lstm_output, context)

# With attention scores
c(tfd, attention_scores) \%<-\%
   layer_temporal_fusion_decoder(
      hidden_units = 30,
      state_size = state_size,
      use_context = TRUE,
      num_heads = 10
   )(lstm_output, context, return_attention_scores=TRUE)
}
