#' Interpretable multi-head attention layer
#'
#' @param state_size
#' @param num_heads Number of attention heads.
#' @param dropout_rate Dropout rate
#'
#' @include layer-scaled-dot-attention.R
#'
#' @references
#' 1. 2. B. Lim, S.O. Arik, N. Loeff, T. Pfiste, [Temporal Fusion Transformers for Interpretable Multi-horizon Time Series Forecasting](https://arxiv.org/abs/1912.09363)(2020)
#' 2. [TFT original implementation by Google](https://github.com/google-research/google-research/blob/4808a726f4b126ea38d49cdd152a6bb5d42efdf0/tft/libs/tft_model.py#L278)
#'
#' @examples
#' library(keras)
#' lookback   <- 28
#' horizon    <- 14
#' all_steps  <- lookback + horizon
#' state_size <- 5
#'
#' queries <- layer_input(c(horizon, state_size))
#' keys    <- layer_input(c(all_steps, state_size))
#' values  <- layer_input(c(all_steps, state_size))
#'
#' imh_attention <-
#'    layer_interpretable_mh_attention(
#'       state_size = state_size, num_heads = 10
#'    )(queries, keys, values)
#'
#' model <-
#'    keras_model(
#'      inputs  = list(queries, keys, values),
#'      outputs = imh_attention
#'   )
#'
#' past <- rand_array(32, 28, 5)
#' fut  <- rand_array(32, 14, 5)
#' both <- abind::abind(past, fut, along=2)
#'
#' model(list(fut, both, both))
#'
#' # With attention score
#' c(imh_attention, attn_score) %<-%
#'    layer_interpretable_mh_attention(
#'       state_size = state_size, num_heads = 10
#'    )(queries, keys, values, return_attention_scores=TRUE)
#'
#' model <-
#'    keras_model(
#'      inputs  = list(queries, keys, values),
#'      outputs = c(imh_attention, attn_score)
#'   )
#'
#' c(out, attn) %<-% model(list(fut, both, both))
#' @export
layer_interpretable_mh_attention <- keras::new_layer_class(

  # Dimensions:
  # queries tensor - q: [num_samples x num_future_steps x state_size]
  # keys tensor - k: [num_samples x (num_total_steps) x state_size]
  # values tensor - v: [num_samples x (num_total_steps) x state_size]

  classname = "InterpretableMHAttention",

  initialize = function(state_size, num_heads, dropout_rate = 0. , ...){

    super()$`__init__`(...)

    self$state_size   <- state_size
    self$num_heads    <- num_heads
    self$dropout_rate <- dropout_rate
    self$d_k <- self$d_v <- state_size %/% num_heads

  },

  build = function(input_shape){

    self$vs_layer  <- layer_dense(units = self$d_v)
    self$dropout_1 <- layer_dropout(rate = self$dropout_rate)
    self$dropout_2 <- layer_dropout(rate = self$dropout_rate)

    for (i in 1:self$num_heads) {
      self[[glue::glue("q_{i}")]] <-
        layer_dense(units = self$d_k, use_bias = FALSE)

      self[[glue::glue("k_{i}")]] <-
        layer_dense(units = self$d_k, use_bias = FALSE)

    }

    self$attention <- layer_scaled_dot_attention(dropout_rate = self$dropout_rate)
    self$w_o <- layer_dense(units = self$state_size, use_bias = FALSE)
  },

  call = function(q, k, v, mask = NULL, return_attention_scores=FALSE){

    heads <- list()
    attentions <- list()

    for (i in 1:self$num_heads) {

      # Na wyjściu są puste tensory!
      qs <- self[[glue::glue("q_{i}")]](q)
      ks <- self[[glue::glue("q_{i}")]](k)
      vs <- self$vs_layer(v)

      c(head, attention) %<-% self$attention(
        qs, ks, vs, mask, return_attention_scores=TRUE
      )

      if (!is.null(self$dropout_rate))
        head <- self$dropout_1(head)

      heads <- append(heads, head)
      attentions <- append(attentions, attention)
    }

    if (self$num_heads > 1) {
      attention_output <- k_stack(heads)
      attention_score  <- k_stack(attentions)
      # take average along heads
      attention_output <- k_mean(attention_output, axis = 1)
      attention_score  <- k_mean(head, axis = 1)
    } else {
      attention_output <- heads[[1]]
      attention_score  <- attentions[[1]]
    }

    outputs <- self$w_o(attention)

    if (!is.null(self$dropout_rate))
      outputs <- self$dropout_2(outputs)

    if (return_attention_scores)
      return(list(outputs, q))
    else
      return(outputs)

  }

)
