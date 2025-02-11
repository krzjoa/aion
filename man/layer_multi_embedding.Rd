% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/layer-multi-embedding.R
\name{layer_multi_embedding}
\alias{layer_multi_embedding}
\title{Multiple embeddings in one layer}
\usage{
layer_multi_embedding(object, input_dims, output_dims, new_dim = FALSE, ...)
}
\arguments{
\item{object}{What to compose the new \code{Layer} instance with. Typically a
Sequential model or a Tensor (e.g., as returned by \code{layer_input()}).
The return value depends on \code{object}. If \code{object} is:
\itemize{
\item missing or \code{NULL}, the \code{Layer} instance is returned.
\item a \code{Sequential} model, the model with an additional layer is returned.
\item a Tensor, the output tensor from \code{layer_instance(object)} is returned.
}}

\item{new_dim}{If TRUE, new dimension is created instead of stacking outputs
in the same dimension}
}
\description{
Multiple embeddings in one layer
}
\examples{
# ==========================================================================
#                          SIMPLE CONCATENATION
# ==========================================================================

inp <- layer_input(c(28, 3))
emb <- layer_multi_embedding(input_dims = c(4, 6, 8), output_dims = c(3, 4, 5))(inp)

emb_model <- keras_model(inp, emb)

dummy_input <- array(1, dim = c(1, 28, 3))
dummy_input[,,1] <- sample(4,size = 28, replace = TRUE)
dummy_input[,,2] <- sample(6,size = 28, replace = TRUE)
dummy_input[,,3] <- sample(8,size = 28, replace = TRUE)

out <- emb_model(dummy_input)
dim(out)
# ==========================================================================
#                              ONE VARIABLE
# ==========================================================================

inp <- layer_input(c(32, 1))
emb <- layer_multi_embedding(input_dims = 10, output_dims = 2)(inp)

# ==========================================================================
#                              NEW DIMESNION
# ==========================================================================

inp <- layer_input(c(28, 3))
emb <- layer_multi_embedding(input_dims = c(4, 6, 8), output_dims = 5, new_dim = TRUE)(inp)

emb_model <- keras_model(inp, emb)

dummy_input <- array(1, dim = c(1, 28, 3))
dummy_input[,,1] <- sample(4,size = 28, replace = TRUE)
dummy_input[,,2] <- sample(6,size = 28, replace = TRUE)
dummy_input[,,3] <- sample(8,size = 28, replace = TRUE)

out <- emb_model(dummy_input)
dim(out)
}
