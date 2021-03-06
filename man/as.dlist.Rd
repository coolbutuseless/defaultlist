% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/defaultlist.R
\name{as.dlist}
\alias{as.dlist}
\title{Coerce object to list with a default value}
\usage{
as.dlist(x, all.names = FALSE, sorted = FALSE, ..., .default)
}
\arguments{
\item{x}{object}

\item{all.names}{a logical indicating whether to copy all values or (default)
only those whose names do not begin with a dot.}

\item{sorted}{a logical indicating whether the names of the resulting list
should be sorted (increasingly). Note that this is somewhat costly,
but may be useful for comparison of environments.}

\item{...}{objects, possibly named.}

\item{.default}{default value to return when item not in list}
}
\description{
Coerce object to list with a default value
}
