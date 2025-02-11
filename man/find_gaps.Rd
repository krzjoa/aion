% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{find_gaps}
\alias{find_gaps}
\title{Check if time series in the panel dataset contain time gaps.}
\usage{
find_gaps(data, key, index)
}
\arguments{
\item{data}{A \verb{[data.table::data.table()]} instance}
}
\value{
Logical value - TRUE if input data contains time gaps.
}
\description{
Check if time series in the panel dataset contain time gaps.
}
\examples{
glob_econ <- as.data.table(tsibbledata::global_economy)
find_gaps(glob_econ, 'Country', 'Year')
glob_econ <- glob_econ[Year != 1970]
find_gaps(glob_econ, 'Country', 'Year')
}
