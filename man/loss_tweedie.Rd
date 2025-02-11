% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loss-tweedie.R
\name{loss_tweedie}
\alias{loss_tweedie}
\title{Tweedie Loss (negative log likelihood)}
\usage{
loss_tweedie(...)
}
\arguments{
\item{p}{Power parameter from the \link{0, 2} range. It allows to choose a desired distribution from the Tweedie distributions family.}
}
\description{
Tweedie Loss (negative log likelihood)
}
\note{
For the moment, you can only use \code{loss_quantile} to instantiate a class
and not call directly like other loss in \code{keras}. Please see:
\href{https://github.com/rstudio/keras/issues/1342}{#1342 issue}
}
\examples{
y_pred <- array(runif(60), c(2, 10, 1))
y_true <- array(runif(20), c(2, 10, 1))

loss_tweedie(p = 1.5, reduction = 'auto')(y_true, y_pred)
loss_tweedie(p = 1.5, reduction = 'sum')(y_true, y_pred)
}
\references{
\enumerate{
\item \href{https://towardsdatascience.com/tweedie-loss-function-for-right-skewed-data-2c5ca470678f}{Tweedie Loss Function}
\item \href{https://stats.stackexchange.com/questions/123598/tweedie-p-parameter-interpretation}{p parameter}
}
}
